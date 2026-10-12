//
//  LoadState.swift
//  SwiftUIPractice
//
//  Created by Park Kwonyong on 10/2/26.
//

enum LoadState<Value> {
  case idle
  case loading
  case loaded(Value)
  case failed(Error)
}

extension LoadState {

  var value: Value? {
    if case .loaded(let value) = self { return value }
    return nil
  }

  var error: Error? {
    if case .failed(let error) = self { return error }
    return nil
  }
}
