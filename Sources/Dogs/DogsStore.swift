//
//  DogsState.swift
//  
//
//  Created by kwanghyun won on 2021/08/24.
//

import ComposableArchitecture

// state
public struct Dog: Equatable {
  public let breed: String
  public let subBreeds: [String]
}

public struct DogsState: Equatable {
  
  public var filterQuery: String
  public var dogs: [Dog]
  
  static let initial = DogsState(filterQuery: "", dogs: [])
  
  public init(filterQuery: String, dogs: [Dog]) {
    self.filterQuery = filterQuery
    self.dogs = dogs
  }
}

extension DogsState {
  public var view: DogsView.ViewState {
    DogsView.ViewState.convert(from: self)
  }
}

/// Reducer
extension DogsState {
  public static let reducer = Reducer<DogsState, DogsAction, DogsEnvironment> { state, action, env in
    switch action {
    
    case .breedWasSelected(name: let name):
      return .none
    case .dogsLoaded(let dogs):
      state.dogs = dogs
      return .none
    case .filterQueryChanged(let query):
      state.filterQuery = query
      return .none
    case .loadDogs:
      return env.loadDogs().map(DogsAction.dogsLoaded)
    }
  }
}

//action
public enum DogsAction: Equatable {
  case breedWasSelected(name: String)
  case dogsLoaded([Dog])
  case filterQueryChanged(String)
  case loadDogs
}

extension DogsAction {
  public static func view(_ localAction: DogsView.ViewAction) -> Self {
    switch localAction {
    case .cellWasSelected(let breed):
      return .breedWasSelected(name: breed)
    case .onAppear:
      return .loadDogs
    case .filterTextChanged(let newValue):
      return .filterQueryChanged(newValue)
    }
  }
}

// environment
public struct DogsEnvironment {
  public var loadDogs: () -> Effect<[Dog], Never>
}

extension DogsEnvironment {
  // API Client대신 fake data
  static let fake = DogsEnvironment(loadDogs: {
    Effect(value: [
      Dog(breed: "bullDog", subBreeds: ["Boston", "english", "french"]),
      Dog(breed: "시고르자브르", subBreeds: [])
    ])
    //    .delay(for: .second(2), scheduler: DispatchQueue.main)
    .eraseToEffect()
  })
  
  static let failing = DogsEnvironment(loadDogs: {
    .failing("DogsEnvironment.loadDogs")
  })
  
  private struct DogsResponse: Codable {
    let message: [String: [String]]
  }
  
  public static let live = DogsEnvironment(
    loadDogs: {
      URLSession
        .shared
        .dataTaskPublisher(for: URL(string: "https://dog.ceo/api/breeds/list/all")!)
        .map(\.data)
        .decode(type: DogsResponse.self, decoder: JSONDecoder())
        .map { response in
          response
            .message
            .map(Dog.init)
            .sorted { $0.breed < $1.breed }
        }
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    }
  )
}
