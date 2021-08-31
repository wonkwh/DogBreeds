//
//  File.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import Foundation
import ComposableArchitecture
import Dogs
import Breed
/// ShatedStates
extension DogsState {
  init(initialState: DogsInternalState, dogs: [Dog]) {
    self.init(filterQuery: initialState.filterQuery, dogs: dogs)
  }
}

struct DogsInternalState: Equatable {
  var filterQuery: String
  
  init() {
    self.filterQuery = ""
  }
  
  init(state: DogsState) {
    self.filterQuery = state.filterQuery
  }
}

public struct AppState: Equatable {
  var dogs: [Dog]
  
  var dogsInternal = DogsInternalState()
  var breedState: BreedState?
  
  public static let inital = AppState(dogs: [], breedState: nil)
}

extension AppState {
  var dogsState: DogsState {
    get {
      DogsState(initialState: dogsInternal, dogs: dogs)
    }
    set {
      dogsInternal = .init(state: newValue)
      dogs = newValue.dogs
    }
  }
}

public enum AppAction: Equatable {
  case breed(BreedAction)
  case breedsDisappeared
  case dogs(DogsAction)
}

/// reducer
extension AppState {
  static let reducerCore = Reducer<AppState, AppAction, Void> { state, action, _ in
    switch action {
    // 1.
    case .breed:
      return .none
    // 2.
    case .breedsDisappeared:
      state.breedState = nil
      return .none
    // 3.
    case .dogs(.breedWasSelected(let breed)):
      guard let dog = state.dogs.first(where: { $0.breed.lowercased() == breed.lowercased() }) else { fatalError() }
      state.breedState = BreedState(dog: dog, imageURLString: nil)
      return .none
    // 4.
    case .dogs:
      return .none
    }
  }
}

public extension AppState {
  static let reducer = Reducer<AppState, AppAction, Void>
    .combine(
      AppState.reducerCore,
      DogsState
        .reducer
        .pullback(
          state: \.dogsState,
          action: /AppAction.dogs,
          environment: { _ in DogsEnvironment.live }
        ),
      BreedState
        .reducer
        .optional()
        .pullback(
          state: \.breedState,
          action: /AppAction.breed,
          environment: { _ in BreedEnvironment.live }
        )
    )
}

