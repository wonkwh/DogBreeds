//
//  DogsClient.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import ComposableArchitecture

public struct Dog: Equatable {
  let breed: String
  let subBreeds: [String]
}

private struct DogsResponse: Codable {
  let message: [String: [String]]
}

public struct DogsClient {
  public var loadDogs: () -> Effect<[Dog], Never>
  public struct Failure: Error, Equatable {}
}

extension DogsClient {
  //  public static let live = Self(
  //    reviews: { id in
  //      URLSession.shared.dataTaskPublisher(
  //        for: URL(string: "https://itunes.apple.com/jp/rss/customerreviews/id=\(id)/json")!
  //      )
  //      .map(\.data)
  //      .decode(type: AppStoreReviewResponse.self, decoder: JSONDecoder.init())
  //      .map(\.feed.entry)
  //      .mapError { _ in Failure() }
  //      .eraseToEffect()
  //    }
  //  )
  
  static let live = Self(
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

extension DogsClient {
  public static let failing = Self(
    loadDogs: { .failing("DogsClient.loadDogs")}
  )
}
