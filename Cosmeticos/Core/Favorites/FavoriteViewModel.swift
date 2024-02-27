//
//  FavoriteViewModel.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 27/02/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoritedProducts: [ UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForFavorites() {
        guard let authDataResult = try? AuthenticationManager.shared.getCurrentUser() else { return }
        /*
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid) { [weak self] products in
            self?.userFavoritedProducts = products
        }*/
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userFavoritedProducts = products
            }
            .store(in: &cancellables)
    }
    
    /*func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getCurrentUser()
            self.userFavoritedProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
        }
    }*/
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getCurrentUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId:authDataResult.uid, favoriteProductId: favoriteProductId)
           // getFavorites()
        }
    }
    
}
