//
//  DogsStoreTests.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import XCTest
import ComposableArchitecture
@testable import Dogs

class DogsStoreTests: XCTestCase {
  
  func testStore(initialState: DogsState = .initial)
  -> TestStore<DogsState, DogsState, DogsAction, DogsAction, DogsEnvironment> {
    TestStore(initialState: initialState, reducer: DogsState.reducer, environment: .failing)
  }
  
  func testDogsLoad() {
    let store = testStore()
    let expectedDogs = [Dog(breed: "dog", subBreeds: [])]
    
    // Mock loadDogs
    store.environment.loadDogs = {
      Effect(value: expectedDogs)
    }
    // sending a action
    store.send(.loadDogs)
    
    // assertion
    store.receive(.dogsLoaded(expectedDogs)) {
      $0.dogs = expectedDogs
    }
  }
  
  func testFilterQueryChaqnged() {
    let store = testStore()
    let query = "advbjiodf"
    
    store.send(.filterQueryChanged(query)) {
      $0.filterQuery = query
    }
  }
}
