//
//  ProductCellView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 05/02/24.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(.rect(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text("$" + String(product.price ?? 0))
                Text("Price: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "n/a"))
                Text("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundStyle(.secondary)

        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "gsgsgs", description: "shshshs", price: 3, discountPercentage: 4, rating: 4, stock: 2, brand: "dgdgdgd", category: "gsgdgd", thumbnail: "jshsjsj", images: [] ))
}
