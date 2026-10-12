//
//  ProductLikeLIst.swift
//  SwiftUIPractice
//
//  Created by dejay on 10/12/26.
//

import SwiftUI
import Kingfisher

struct ProductLikeListView: View {
  
  @State private var viewModel: ProductLikeListViewModel
  @Environment(FavoriteManager.self) private var favoritManager
  
  private let container: AppContainer
  init(container: AppContainer) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductLikeListViewModel())
  }
  
  var body: some View {
    ProductList(container: container, products: viewModel.state.value ?? [])
      .navigationTitle("찜목록")
      .task { await viewModel.loadProductList(favoriteIDs: favoritManager.loadLikeList()) }
  }
}

struct ProductLikeList: View {
  let container: AppContainer
  let productsLike: [ProductResult]
  var body: some View {
    List(productsLike, id: \.id) { productLike in
      NavigationLink(value: productLike) {
        ProductLikeListCell(product: productLike)
      }
    }
    .navigationDestination(for: ProductResult.self) { selectedProduct in
      ProductDetailView(container: container, productId: selectedProduct.id)
    }
  }
}

struct ProductLikeListCell: View {
  let product: ProductResult
  var body: some View {
    HStack {
      KFImage(URL(string: product.thumbnail ?? ""))
        .placeholder({
          ProgressView()
        }).onFailure({ error in
          print("이미지 로드 실패: \(error)")
        })
      .resizable()
      .frame(width: 60, height: 60)
        
      VStack(alignment: .leading) {
        Text(product.title)
          .font(Font.body.bold())
        Text(product.brand ?? "")
          .font(Font.body.italic())
        Text(String(product.price))
      }
    }
  }
}

#Preview {
  ProductLikeListView(container: AppContainer())
}
