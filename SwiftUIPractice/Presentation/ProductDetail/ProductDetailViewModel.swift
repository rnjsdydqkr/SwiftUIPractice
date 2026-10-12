//
//  ProductDetailViewModel.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import Observation

@Observable
final class ProductDetailViewModel {
  
  private(set) var state: LoadState<ProductResult> = .idle
  
  private let repository: ProductRepositoryProtocol
  let productId: Int
  init(repository: ProductRepositoryProtocol, productId: Int) {
    self.repository = repository
    self.productId = productId
  }
  
  var isLiked: Bool = false
  
  func loadProductDetail() async {
    state = .loading
    let result = await repository.getDetailProduct(id: productId)
    switch result {
    case .success(let res):
      state = .loaded(res)
    case .failure(let error):
      state = .failed(error)
    }
  }
}
