//
//  ProductRepository.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

struct ProductRepository: ProductRepositoryProtocol {
  private let network: ProductNetworkProtocol
  private let userDefaults: FavoriteUserDefaultsProtocol
  init(network: ProductNetworkProtocol, userDefaults: FavoriteUserDefaultsProtocol) {
    self.network = network
    self.userDefaults = userDefaults
  }
  func getProducts() async -> Result<ProductResponseResult, NetworkError> {
    await network.getProducts()
  }
  func getDetailProduct(id: Int) async -> Result<ProductResult, NetworkError> {
    await network.getDetailProduct(id: id)
  }
  
  func load() -> Set<String> {
    userDefaults.load()
  }
  func save(_ ids: Set<String>) {
    userDefaults.save(ids)
  }
  
}
