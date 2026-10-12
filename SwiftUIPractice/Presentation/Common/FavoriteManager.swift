//
//  FavoriteManager.swift
//  SwiftUIPractice
//
//  Created by dejay on 10/12/26.
//

import SwiftUI
import Observation

@Observable
class FavoriteManager {
  private let repository: ProductRepositoryProtocol
  private var favoriteIDs: Set<String> = []
  init(repository: ProductRepositoryProtocol) {
    self.repository = repository
    self.favoriteIDs = repository.load()
  }
  
  func isLiked(_ id: String) -> Bool {
    return favoriteIDs.contains(id)
  }
  
  func toggleLike(_ id: String) {
    if favoriteIDs.contains(id) {
      favoriteIDs.remove(id)
    } else {
      favoriteIDs.insert(id)
    }
    
    repository.save(favoriteIDs)
  }
  
}
