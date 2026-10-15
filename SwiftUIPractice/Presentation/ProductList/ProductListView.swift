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
    List(Array(products.enumerated()), id: \.element.id) { index, product in
      NavigationLink(value: product) {
        ProductListCell(products: products, productIndex: index)
      }
    }
    .navigationDestination(for: ProductResult.self) { selectedProduct in
      ProductDetailView(container: container, productId: selectedProduct.id)
    }
  }
}

struct ProductListCell: View {
  @Environment(\.displayScale) private var displayScale
  
  let products: [ProductResult]
  let productIndex: Int
  let itemSize = CGSize(width: 60, height: 60)
  private var kingfisherOptions: KingfisherOptionsInfo {
    [
      .processor(DownsamplingImageProcessor(size: itemSize)),
      .scaleFactor(displayScale),
      .cacheOriginalImage,
      .alsoPrefetchToMemory
    ]
  }
  var body: some View {
    HStack {
      KFImage(URL(string: products[productIndex].thumbnail ?? ""))
        .setProcessor(DownsamplingImageProcessor(size: itemSize))
        .scaleFactor(displayScale)
        .cacheOriginalImage()
        .placeholder({
          ProgressView()
        }).onFailure({ error in
          print("이미지 로드 실패: \(error)")
        })
      .resizable()
      .frame(width: itemSize.width, height: itemSize.height)
      .onAppear {
        preFetchNextImages(products: products, currentIndex: productIndex)
      }
        
      VStack(alignment: .leading) {
        Text(products[productIndex].title)
          .font(Font.body.bold())
        Text(products[productIndex].brand ?? "")
          .font(Font.body.italic())
        Text(String(products[productIndex].price))
      }
    }
  }
  
  private func preFetchNextImages(products: [ProductResult], currentIndex: Int) {
    let nextIndex: Int = currentIndex + 1
    let lastIndex: Int = min(currentIndex + 6, products.count - 1)
    guard nextIndex <= lastIndex else { return }
    
    let urlsToPrefetch: [URL] = products[nextIndex...lastIndex].compactMap{ URL(string: $0.thumbnail ?? "") }
    
    ImagePrefetcher(urls: urlsToPrefetch, options: kingfisherOptions).start()
  }
  
}

#Preview {
  ProductListView(container: AppContainer())
}
