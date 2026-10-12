//
//  AppContainer.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

@MainActor
final class AppContainer {
  private lazy var productNetwork: ProductNetworkProtocol =
  ProductNetwork(manager: NetworkManager(session: ProductSession()))

  private lazy var productRepository: ProductRepositoryProtocol =
  ProductRepository(network: productNetwork, userDefaults: FavoriteUserDefaults())
  
  lazy var favoriteManager: FavoriteManager = FavoriteManager(repository: productRepository)
  
  func makeProductListViewModel() -> ProductListViewModel {
    ProductListViewModel(repository: productRepository)
  }
  
  func makeProductDetailViewModel(productId: Int) -> ProductDetailViewModel {
    ProductDetailViewModel(repository: productRepository, productId: productId)
  }
  
  func makeProductLikeListViewModel() -> ProductLikeListViewModel {
    ProductLikeListViewModel(repository: productRepository)
  }
}
