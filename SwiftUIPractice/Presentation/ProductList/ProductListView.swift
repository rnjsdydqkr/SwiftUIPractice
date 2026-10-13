//
//  ProductListView.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI
import Kingfisher

struct ProductListView: View {
  
  @State private var viewModel: ProductListViewModel
  @Environment(FavoriteManager.self) private var favoritManager
  
  private let container: AppContainer
  init(container: AppContainer) {
    self.container = container
    _viewModel = State(initialValue: container.makeProductListViewModel())
  }
  
  var body: some View {
    ProductList(container: container, products: viewModel.state.value ?? [])
      .navigationTitle("목록")
      .task { await viewModel.loadProductList() }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(value: Route.likeList) {
            Image(systemName: "heart.fill")
              .foregroundColor(.gray)
          }
          .navigationDestination(for: Route.self) { route in
            switch route {
            case .likeList:
              ProductLikeListView(container: container)
            }
          }

        }
      }
  }
  
}

struct ProductList: View {
  let container: AppContainer
  let products: [ProductResult]
  var body: some View {
    List(products, id: \.id) { product in
      NavigationLink(value: product) {
        ProductListCell(product: product)
      }
    }
    .navigationDestination(for: ProductResult.self) { selectedProduct in
      ProductDetailView(container: container, productId: selectedProduct.id)
    }
  }
}

struct ProductListCell: View {
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
  ProductListView(container: AppContainer())
}
