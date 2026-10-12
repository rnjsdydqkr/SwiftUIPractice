//
//  ProductResult.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/1/26.
//

import Foundation

struct ProductResponseResult: Decodable, Sendable {
  let products: [ProductResult]
  let total: Int
  let skip: Int
  let limit: Int
}

struct ProductResult: Decodable, Sendable, Hashable {
  let id: Int
  let title: String
  let description: String

  let brand: String?

  let price: Double
  let discountPercentage: Double
  let rating: Double
  let stock: Int

  let availabilityStatus: String?
  let thumbnail: String?
  let images: [String]?
  let reviews: [ProductReview]?
  
  static func == (lhs: ProductResult, rhs: ProductResult) -> Bool {
    lhs.id == rhs.id
  }
}

struct ProductReview: Decodable, Sendable, Hashable {
  let reviewerName: String
  let rating: Int
  let comment: String
}
