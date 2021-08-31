//
//  BreedEnvironment.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import ComposableArchitecture

public struct BreedEnvironment {
  var loadDogImage: (_ breed: String) -> Effect<String, Never>
}

extension BreedState {
  public static let reducer = Reducer<BreedState, BreedAction, BreedEnvironment> { state, action, environment in
    switch action {
    case .breedImageURLReceived(let urlString):
      state.imageURLString = urlString
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
  public static let fake = BreedEnvironment(
    loadDogImage: { _ in
      Effect(value: "https://images.dog.ceo/breeds/hound-blood/n02088466_9069.jpg")
        .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        .eraseToEffect()
    }
  )
  
  private struct BreedImageResponse: Codable {
    let message: String?
  }
  
  public static let live = BreedEnvironment(
    loadDogImage: { breed in
      URLSession
        .shared
        .dataTaskPublisher(for: URL(string: "https://dog.ceo/api/breed/\(breed)/images/random")!)
        .map(\.data)
        .decode(type: BreedImageResponse.self, decoder: JSONDecoder())
        .compactMap(\.message)
//        .map(URL.init(string:))
        .replaceError(with: "")
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    }
  )
}
#endif

