//
//  BreedState.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import Foundation
import Dogs

public struct BreedState: Equatable {
  
  public let dog: Dog
  public var imageURLString: String?
  
  public init(dog: Dog, imageURLString: String? = nil) {
    self.dog = dog
    self.imageURLString = imageURLString
  }
}

// MARK: - Scope
extension BreedState {
  public var view: BreedView.ViewState {
    BreedView.ViewState.convert(from: self)
  }
}

public enum BreedAction: Equatable {
  case breedImageURLReceived(String?)
  case getBreedImageURL
}

// MARK: - Scope
extension BreedAction {
  public static func view(_ localAction: BreedView.ViewAction) -> Self {
    switch localAction {
    case .onAppear:
      return .getBreedImageURL
    }
  }
}
