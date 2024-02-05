//
//  ProductView.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 05/02/24.
//

import SwiftUI

struct ProductView: View {
    
    @StateObject private var viewModel = ProductViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
            
        })
        .listStyle(InsetListStyle())
        .onAppear {
            viewModel.getProducts()
        }
    }
}

#Preview {
    ProductView()
}