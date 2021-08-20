//
//  File.swift
//  
//
//  Created by kwanghyun won on 2021/08/20.
//

import XCTest
@testable import DogBreeds

class DogsViewStateConverterTest: XCTestCase {
  func testViewStateFilterTextGoesFromStateFilterQuery() {
    //given
    let filterQuery = "filter"
    //when
    let viewState = DogsView.ViewState.convert(from: .init(filterQuery: filterQuery, dogs: []))
    //then
    XCTAssertEqual(viewState.filterText, filterQuery)
  }
  
  func testViewStateLoadingStateIsLoadingIfStateDogsAndFilterQueryIsEmpty() {
    // When
    let viewState = DogsView.ViewState.convert(from: .init(filterQuery: "", dogs: []))
    XCTAssertEqual(viewState.loadingState, .loading)
  }
  
  func testViewStateLoadingStateIsLoadedGoesFirstLetterCapitalizedStateDogsBreedWithEmptyFilterQuery() {
    // Given
    let dogs = [Dog(breed: "breed0", subBreeds: []), Dog(breed: "breed1", subBreeds: [])]
    // When
    let viewState = DogsView.ViewState.convert(from: DogsState(filterQuery: "", dogs: dogs))
    // Then
    XCTAssertEqual(viewState.loadingState, .loaded(breed: ["Breed0", "Breed1"]))
  }
  
  func testViewStateLoadingStateIsLoadedGoesFirstLetterCapitalizedStateDogsBreedFilteredContainsByFilterQuery() {
    // Given
    let breed0 = "Abc0"
    let breed1 = "Abc1"
    let breed2 = "Def0"
    let breed3 = "Def1"
    let dogs = [breed0, breed1, breed2, breed3].map { Dog(breed: $0, subBreeds: []) }
    // When
    let viewState = DogsView.ViewState.convert(from: DogsState(filterQuery: "abc", dogs: dogs))
    // Then
    XCTAssertEqual(viewState.loadingState, .loaded(breed: [breed0, breed1]))
    
  }
}

