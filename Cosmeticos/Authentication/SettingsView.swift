//
//  SettingsView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 21/12/23.
//

import SwiftUI

@MainActor
final class SettignsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getCurrentUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }

    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authResult = try  AuthenticationManager.shared.getCurrentUser()
        
        guard let email = authResult.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "higino@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "asd123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAcount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkEmailAcount() async throws {
        let email = "higino@gmail.com"
        let password = "123456"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
    
  
}




struct SettingsView: View {
    
    @StateObject private var viewModel = SettignsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete cccount")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    
  
    private var emailSection: some View{
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Updated")
                    } catch {
                        print(error)
                    }
                }
            }
            
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Updated")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
    
    private var anonymousSection: some View{
        Section {
            
            Button("Link Google Accoun") {
                Task {
                    do {
                        try await viewModel.linkGoogleAcount()
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Link Email Accoun") {
                Task {
                    do {
                        try await viewModel.linkEmailAcount()
                    } catch {
                        print(error)
                    }
                }
            }
            
        } header: {
            Text("Create Accounte")
        }
    }
        
}


