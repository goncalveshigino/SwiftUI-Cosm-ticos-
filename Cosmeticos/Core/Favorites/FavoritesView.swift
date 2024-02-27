//
//  FavoritesView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 19/02/24.
//

import SwiftUI


struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var didAppear: Bool = false
    
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
        .onFirstAppear {
            viewModel.addListenerForFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}




