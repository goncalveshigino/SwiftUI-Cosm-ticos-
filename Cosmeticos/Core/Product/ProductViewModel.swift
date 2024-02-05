//
//  ProductViewModel.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 05/02/24.
//

import Foundation


@MainActor
final class ProductViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    
    func filterSelected(option: FilterOption) async throws {
        
                switch option {
                case .noFilter:
                    self.products = try await ProductsManager.shared.getAllProducts()
                case .priceHigh:
                    self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: true)
                case .priceLow:
                    self.products = try await ProductsManager.shared.getAllProductsSortedByPrice(descending: false)
                }
        
        self.selectedFilter = option
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.getProducts()
    }
    
    func getProducts() {
        Task {
            self.products = try await  ProductsManager.shared.getAllProducts(
                priceDescending: selectedFilter?.priceDescending, 
                forCategory: selectedCategory?.categoryKey
            )
        }
    }
    
}
