//
//  FavoriteUserDefaults.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

protocol FavoriteUserDefaultsProtocol {
  func load() -> Set<String>
  func save(_ ids: Set<String>)
}

struct FavoriteUserDefaults: FavoriteUserDefaultsProtocol {

  private let defaults: UserDefaults
  private let key: String

  init(defaults: UserDefaults = .standard, key: String = "favoriteProductIds") {
    self.defaults = defaults
    self.key = key
  }

  func load() -> Set<String> {
    let stored = defaults.array(forKey: key) as? [String] ?? []
    return Set(stored)
  }

  func save(_ ids: Set<String>) {
    defaults.set(ids.sorted(), forKey: key)
  }
}
