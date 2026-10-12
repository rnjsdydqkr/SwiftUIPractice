//
//  ProductLikeLIstViewModel.swift
//  SwiftUIPractice
//
//  Created by dejay on 10/12/26.
//

import Foundation
import Observation

@Observable
final class ProductLikeListViewModel {
  private(set) var state: LoadState<[ProductResult]> = .idle
  
  private let repository: ProductRepositoryProtocol
  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
  }
  
  func loadProductList() async {
    state = .loading
    let result = await repository.getProducts()
    switch result {
    case .success(let res):
      state = .loaded(res.products)
    case .failure(let error):
      print(error.localizedDescription)
      state = .failed(error)
    }
  }
  
}
