//
//  BreedStoreTests.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import XCTest
import ComposableArchitecture
@testable import Breed
@testable import Dogs

class BreedStoreTests: XCTestCase {
  
  func testStore(initialState: BreedState)
    -> TestStore<BreedState, BreedState, BreedAction, BreedAction, BreedEnvironment> {
    TestStore(initialState: initialState, reducer: BreedState.reducer, environment: .failing)
  }
  
  /// imageLoading
  func testBreedImageLoad()() {
    let breedName = "Breed"
    let initialState = BreedState(dog: Dog(breed: breedName, subBreeds: []) , imageURLString: nil)
    let store = testStore(initialState: initialState)
    
    let expectedURLString = "breed.com"
    store.environment.loadDogImage = {
      XCTAssertEqual($0, breedName)
      return Effect(value: expectedURLString)
    }
    
    store.send(.getBreedImageURL)
    store.receive(.breedImageURLReceived(expectedURLString)) {
      $0.imageURLString = expectedURLString
    }
  }
}
