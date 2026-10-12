//
//  ProductDetailView.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI

struct ProductDetailView: View {
  
  @State private var viewModel: ProductDetailViewModel
  
  private let container: AppContainer
  init(container: AppContainer, productId: Int) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductDetailViewModel(productId: productId))
  }

  var body: some View {
    ProductDetail(container: container, product: viewModel.state.value)
      .navigationTitle(viewModel.state.value?.title ?? "")
      .task { await viewModel.loadProductDetail() }
  }
}

struct ProductDetail: View {
  let container: AppContainer
  let product: ProductResult?
  var body: some View {
    VStack {
      AsyncImage(url: URL(string: (product?.images?.first ?? product?.thumbnail) ?? "")) { image in
        image.image?.resizable()
      }.frame(width: 400, height: 400)
      Text(product?.title ?? "")
      Text(product?.brand ?? "")
      Text(String(product?.price ?? 0))
      Text(product?.description ?? "")
        .padding(20)
    }
  }
}

#Preview {
  ProductDetailView(container: AppContainer(), productId: 1)
}
