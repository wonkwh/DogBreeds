//
//  DogsState.swift
//  
//
//  Created by kwanghyun won on 2021/08/24.
//

import ComposableArchitecture

// state
struct Dog: Equatable {
  let breed: String
  let subBreeds: [String]
}

struct DogsState: Equatable {
  var filterQuery: String
  var dogs: [Dog]
  
  static let initial = DogsState(filterQuery: "", dogs: [])
}

extension DogsState {
  var view: DogsView.ViewState {
    DogsView.ViewState.convert(from: self)
  }
}

extension DogsState {
  static let reducer = Reducer<DogsState, DogsAction, DogsEnvironment> { state, action, env in
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
enum DogsAction {
  case breedWasSelected(name: String)
  case dogsLoaded([Dog])
  case filterQueryChanged(String)
  case loadDogs
}

extension DogsAction {
  static func view(_ localAction: DogsView.ViewAction) -> Self {
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
struct DogsEnvironment {
  var loadDogs: () -> Effect<[Dog], Never>
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
}
