//
//  File.swift
//  
//
//  Created by kwanghyun won on 2021/08/30.
//

import ComposableArchitecture
import SwiftUI
import NukeUI

public struct BreedView: View {
  public init(store: Store<BreedView.ViewState, BreedView.ViewAction>) {
    self.store = store
  }
  
  let store: Store<ViewState, ViewAction>
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyImage(source: viewStore.imageURLString, resizingMode: .aspectFill)
          .frame(width: 300, height: 300)
          
        viewStore
          .subtitle
          .flatMap(Text.init)
          .font(.title)
        
        ForEach(viewStore.subBreeds, id: \.self) { breed in
          VStack {
            HStack {
              Text(breed)
              Spacer()
            }
            Divider()
          }
          .foregroundColor(.primary)
        }
        .padding()
        
      }
      .navigationBarTitle(viewStore.title)
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

/// VeiwState
extension BreedView {
  public struct ViewState: Equatable {
    let title: String
    let subtitle: String?
    let subBreeds: [String]
    let imageURLString: String?
  }
}

/// ViewAction
extension BreedView {
  public enum ViewAction: Equatable {
    case onAppear
  }
}

// MARK: - Converter
extension BreedView.ViewState {
  static func convert(from state: BreedState) -> Self {
    .init(
      title: state.dog.breed.capitalizedFirstLetter,
      subtitle: state.dog.subBreeds.isEmpty ? nil : "Sub-breeds",
      subBreeds: state.dog.subBreeds.map(\.capitalizedFirstLetter),
      imageURLString: state.imageURLString
    )
  }
}
#if DEBUG
struct BreedView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      BreedView(
        store: Store(
          initialState: BreedView.ViewState(
            title: "hound",
            subtitle: "sub-breeds",
            subBreeds: [
              "afghan",
              "basset",
              "blood",
              "english",
              "ibizan",
              "plott",
              "walker"
            ],
            imageURLString: "https://images.dog.ceo/breeds/hound-basset/n02088238_9351.jpg"
          ),
          reducer: .empty,
          environment: ()
        )
      )
    }
  }
}
#endif

