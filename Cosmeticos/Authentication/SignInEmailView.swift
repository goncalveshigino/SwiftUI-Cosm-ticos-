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
    
    
    func verifyEmailAndPassword() {
        guard email.isNoEmpty, password.isNoEmpty else {
            print("No email or password found")
            return
        }
    }
    
    func signUp() async throws {
        verifyEmailAndPassword()
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        verifyEmailAndPassword()
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getCurrentUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
        
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
            
            Button {
               print("Reset Password")
            } label: {
                Text("Forgot password?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding(.trailing)
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
                
            
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

          
            Divider()
                .padding()
            
            NavigationLink {
              Text("Sign Up")
            } label: {
                HStack(spacing:3) {
                    Text("Don't have an account?")
                    
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .padding(.vertical)
            
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
