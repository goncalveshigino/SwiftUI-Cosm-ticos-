//
//  SignInEmailViewModel.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 30/01/24.
//

import Foundation


final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    
    func verifyEmailAndPassword() {
        guard email.isNoEmpty, password.isNoEmpty else { return }
    }
    
    func signUp() async throws {
        verifyEmailAndPassword()
        let authDataResult =  try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signIn() async throws {
        verifyEmailAndPassword()
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getCurrentUser()
        
        guard let email = authUser.email else { throw URLError(.fileDoesNotExist) }
        try await AuthenticationManager.shared.resetPassword(email: email)
        
    }
    
}
