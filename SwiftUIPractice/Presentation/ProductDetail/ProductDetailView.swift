//
//  ProductDetailView.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
  
  @State private var viewModel: ProductDetailViewModel
  @Environment(FavoriteManager.self) private var favoriteManager
  private var isLike: Bool {
    favoriteManager.isLiked(String(viewModel.productId))
  }
  
  private let container: AppContainer
  init(container: AppContainer, productId: Int) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductDetailViewModel(productId: productId))
  }

  var body: some View {
    ProductDetail(container: container, product: viewModel.state.value)
      .navigationTitle(viewModel.state.value?.title ?? "")
      .task { await viewModel.loadProductDetail() }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            favoriteManager.toggleLike(String(viewModel.productId))
          } label: {
            Image(systemName: isLike ? "heart.fill" : "heart")
              .foregroundColor(isLike ? .red : .gray)
          }
        }
      }
  }
}

struct ProductDetail: View {
  let container: AppContainer
  let product: ProductResult?
  var body: some View {
    VStack {
      KFImage(URL(string: (product?.images?.first ?? product?.thumbnail) ?? ""))
        .placeholder({
          ProgressView()
        }).onFailure({ error in
          print("이미지 로드 실패: \(error)")
        })
      .resizable()
      .frame(width: 400, height: 400)
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
