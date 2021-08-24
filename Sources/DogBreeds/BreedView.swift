

import ComposableArchitecture
import NukeUI
import SwiftUI

struct BreedView: View {
  let store: Store<ViewState, ViewAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        GeometryReader { geometry in
          LazyImage(source: viewStore.imageUrl?.absoluteString, resizingMode: .fill)
            .frame(width: geometry.size.width, height: 240, alignment: .center)
            .clipped()
        }
          
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
      }
      .navigationBarTitle(viewStore.title)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

// MARK - ViewState
extension BreedView {
  struct ViewState: Equatable {
    let title: String
    let subtitle: String?
    let subBreeds: [String]
    let imageUrl: URL?
    
    static func convert(from state: BreedState) -> Self {
      .init(
        title: state.dog.breed.capitalizedFirstLetter,
        subtitle: state.dog.subBreeds.isEmpty ? nil : "Sub-breed",
        subBreeds: state.dog.subBreeds.map(\.capitalizedFirstLetter),
        imageUrl: state.imageUrl)
    }
  }
  
  enum ViewAction: Equatable {
    case onAppear
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
            imageUrl: URL(string: "https://images.dog.ceo/breeds/hound-basset/n02088238_9351.jpg")
          ),
          reducer: .empty,
          environment: ()
        )
      )
    }
  }
}
#endif

