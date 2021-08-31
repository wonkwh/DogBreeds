//
//  DogBreedsApp.swift
//  DogBreeds
//
//  Created by kwanghyun won on 2021/08/30.
//

import SwiftUI
import App
import ComposableArchitecture

@main
struct DogBreedsApp: App {
    var body: some Scene {
        WindowGroup {
          RootView(
            store:
              .init(
                initialState: .inital,
                reducer: AppState.reducer,
                environment: ()
              )
          )
        }
    }
}
