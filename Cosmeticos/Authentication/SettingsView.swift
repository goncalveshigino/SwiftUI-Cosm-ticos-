//
//  SettingsView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 21/12/23.
//

import SwiftUI


final class SettignsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
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
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
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
}
