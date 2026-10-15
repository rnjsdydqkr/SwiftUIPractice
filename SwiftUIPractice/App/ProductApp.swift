//
//  ProductApp.swift
//  ProductApp
//
//  Created by Park Kwonyong on 10/1/26.
//

import SwiftUI
import Kingfisher

@main
struct ProductApp: App {
  @State private var container = AppContainer()

  init() {
    ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
    ImageCache.default.diskStorage.config.sizeLimit = 200 * 1024 * 1024
  }

  var body: some Scene {
    WindowGroup {
      RootView(container: container)
        .environment(container.favoriteManager)
    }
  }
}
