//
//  ProductRepositoryProtocol.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

protocol ProductRepositoryProtocol {
  func getProducts() async -> Result<ProductResponseResult, NetworkError>
  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError>
  
  func load() -> Set<String>
  func save(_ ids: Set<String>)
}
