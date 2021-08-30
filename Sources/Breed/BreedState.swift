//
//  BreedState.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import Foundation
import Dogs

struct BreedState: Equatable {
  let dog: Dog
  var imageURLString: String?
}

// MARK: - Scope
extension BreedState {
  var view: BreedView.ViewState {
    BreedView.ViewState.convert(from: self)
  }
}

public enum BreedAction: Equatable {
  case breedImageURLReceived(String?)
  case getBreedImageURL
}

// MARK: - Scope
extension BreedAction {
  static func view(_ localAction: BreedView.ViewAction) -> Self {
    switch localAction {
    case .onAppear:
      return .getBreedImageURL
    }
  }
}
