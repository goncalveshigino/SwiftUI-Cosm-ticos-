//
//  SignInEmailView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 21/12/23.
//

import SwiftUI

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    var isLoading: Bool = false
    
    func verifyEmailAndPassword() {
        guard email.isNoEmpty, password.isNoEmpty else {
            print("No email or password found")
            return
        }
    }
    
    func signUp() async throws {
        isLoading = true
        verifyEmailAndPassword()
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        isLoading = false
    }
    
    func signIn() async throws {
        isLoading = true
        verifyEmailAndPassword()
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        isLoading = false
    }
    
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .font(.subheadline)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.none)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
            
            Button("Sign In") {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
