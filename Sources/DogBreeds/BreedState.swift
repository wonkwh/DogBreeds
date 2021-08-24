//
//  BreedState.swift
//  
//
//  Created by kwanghyun won on 2021/08/24.
//

import ComposableArchitecture

//BreedState
struct BreedState: Equatable {
  let dog:  Dog
  var imageUrl: URL?
  
  var view: BreedView.ViewState {
    BreedView.ViewState.convert(from: self)
  }
}

enum BreedAction: Equatable {
  case breedImageURLReceived(URL?)
  case getBreedImageURL
  
  static func view(_ localAction: BreedView.ViewAction) -> Self {
    switch localAction {
    case .onAppear:
      return .getBreedImageURL
    }
  }
}

struct BreedEnvironment {
  var loadDogImage: (_ breed: String) -> Effect<URL?, Never>
}

extension BreedState {
  static let reducer = Reducer<BreedState, BreedAction, BreedEnvironment> { state, action, environment in
    switch action {
    case .breedImageURLReceived(let url):
      state.imageUrl = url
      return .none
    case .getBreedImageURL:
      return environment
        .loadDogImage(state.dog.breed)
        .map(BreedAction.breedImageURLReceived)
    }
  }
}

#if DEBUG
extension BreedEnvironment {
  static let failing = BreedEnvironment(
    loadDogImage: { _ in .failing("DogsEnvironment.loadDogImage") }
  )
}

extension BreedEnvironment {
  static let fake = BreedEnvironment(
    loadDogImage: { _ in
      Effect(value: URL(string: "https://images.dog.ceo/breeds/hound-blood/n02088466_9069.jpg"))
        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        .eraseToEffect()
    }
  )
}
#endif
