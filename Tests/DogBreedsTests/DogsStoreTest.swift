//
//  DogsStoreTest.swift
//  
//
//  Created by kwanghyun won on 2021/08/24.
//

import Foundation
import XCTest
import ComposableArchitecture

@testable import DogBreeds

class DogsStoreTest: XCTestCase {
  
  func testStore(initialState: DogsState = .initial)
  -> TestStore<DogsState, DogsState, DogsAction, DogsAction, DogsEnvironment> {
    TestStore(initialState: initialState, reducer: DogsState.reducer, environment: .failing)
  }
  
  func testDogsLoad() {
    let store = testStore()
    let expectedDogs = [Dog(breed: "dog", subBreeds: [])]
    
    store.environment.loadDogs = {
      Effect(value: expectedDogs)
    }
    
    store.send(.loadDogs) {
      $0.dogs = expectedDogs
    }

    // TCA 최신버전에서는 없음.. 어떻게 변경해야하는지...
//    store.receive(.dogsLoaded(expectedDogs)) {
//    // 5.
//        $0.dogs = expectedDogs
//    }
  }
  
  func testFilterQueryChanged() {
    let store = testStore()
    let query = "buhund"
    
    store.send(.filterQueryChanged(query)) {
      $0.filterQuery = query
    }
  }
}
