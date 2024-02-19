//
//  FavoritesView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 19/02/24.
//

import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    
    @Published private(set) var userFavoritedProducts: [ UserFavoriteProduct] = []
    
    func getFavorites() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getCurrentUser()
            self.userFavoritedProducts = try await UserManager.shared.getAllUserFavoriteProducts(userId: authDataResult.uid)
        }
    }
    
    func removeFromFavorites(favoriteProductId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getCurrentUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userId:authDataResult.uid, favoriteProductId: favoriteProductId)
            getFavorites()
        }
    }
    
}

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.userFavoritedProducts, id: \.id.self) { item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.getFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
