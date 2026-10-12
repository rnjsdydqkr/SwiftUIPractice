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
  var favoriteIDs: Set<String> = []
  
  func isLiked(_ id: String) -> Bool {
    return favoriteIDs.contains(id)
  }
  
  func toggleLike(_ id: String) {
    if favoriteIDs.contains(id) {
      favoriteIDs.remove(id)
    } else {
      favoriteIDs.insert(id)
    }
  }
}
