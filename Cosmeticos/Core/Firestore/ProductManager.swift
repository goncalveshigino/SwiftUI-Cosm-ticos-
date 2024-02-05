//
//  ProductManager.swift
//  Cosmeticos
//
//  Created by Goncalves Higino on 05/02/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(_ productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId).getDocument(as: Product.self)
    }
    
    func getAllProducts(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
        if let descending, let category {
            return try await getAllProductByPriceAndCategory(descending: descending, category: category)
        } else if let descending {
            return try await getAllProductsSortedByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsForCategory(category: category)
        }
        
        return try await getAllProducts()
    }
    
    private func getAllProducts() async throws -> [Product] {
        try await productsCollection.getDocument(as: Product.self)
    }
    
    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocument(as: Product.self)
    }
    
    private func getAllProductsForCategory(category: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocument(as: Product.self)
    }
    
    private func getAllProductByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
        try await productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getDocument(as: Product.self)
    }
}

extension Query {
    
    func getDocument<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map({ document in
             try document.data(as: T.self)
        })
        
        return products
    }
}
