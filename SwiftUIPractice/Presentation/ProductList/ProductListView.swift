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
  @State private var thumbnailPrefetcher = ProductThumbnailPrefetcher()
  
  let products: [ProductResult]
  let productIndex: Int
  
  var body: some View {
    HStack {
      KFImage(URL(string: products[productIndex].thumbnail ?? ""))
        .setProcessor(ProductThumbnail.processor)
        .scaleFactor(displayScale)
        .cacheOriginalImage()
        .placeholder({
          ProgressView()
        }).onFailure({ error in
          print("이미지 로드 실패: \(error)")
        })
      .resizable()
      .frame(width: ProductThumbnail.size.width, height: ProductThumbnail.size.height)
      .onAppear {
        thumbnailPrefetcher.rowDidAppear(index: productIndex, products: products, displayScale: displayScale)
      }
      .onChange(of: products) {
        thumbnailPrefetcher.stopAll()
      }
      .onDisappear {
        thumbnailPrefetcher.stopAll()
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
  
}

enum ProductThumbnail {
  static let size = CGSize(width: 60, height: 60)
  static let processor = DownsamplingImageProcessor(size: size)
}

@MainActor
final class ProductThumbnailPrefetcher {
  private let prefetchDistance = 6
  private var prefetchedUpTo = -1
  private var activePrefetchers: [(range: ClosedRange<Int>, prefetcher: ImagePrefetcher)] = []
  
  func rowDidAppear(index: Int, products: [ProductResult], displayScale: CGFloat) {
    stopPrefetching(reachedBy: index)
    
    let start = index + 1
    let end = min(index + prefetchDistance, products.count - 1)
    guard start <= end else { return }
    prefetchedUpTo = end
    
    let urlsToPrefetch: [URL] = products[start...end].compactMap {
      URL(string: $0.thumbnail ?? "")
    }
    
    let prefetcher = ImagePrefetcher(urls: urlsToPrefetch, options: options(scale: displayScale))
    prefetcher.start()
    
    activePrefetchers.append((start...end, prefetcher))
  }
  
  func stopAll() {
    activePrefetchers.forEach { $0.prefetcher.stop() }
    activePrefetchers.removeAll()
    prefetchedUpTo = -1
  }
  
  private func stopPrefetching(reachedBy index: Int) {
    let reached = activePrefetchers.filter { $0.range.upperBound <= index }
    reached.forEach { $0.prefetcher.stop() }
    activePrefetchers.removeAll { $0.range.upperBound <= index }
  }
  
  private func options(scale: CGFloat) -> KingfisherOptionsInfo {
    [
      .processor(ProductThumbnail.processor),
      .scaleFactor(scale),
      .cacheOriginalImage,
      .alsoPrefetchToMemory
    ]
  }
}

#Preview {
  ProductListView(container: AppContainer())
}
