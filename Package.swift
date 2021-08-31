// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DogBreeds",
  platforms: [.iOS(.v14)],
  products: [
    .library(name: "App", targets: ["App"]),
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "Dogs", targets: ["Dogs"]),
    .library(name: "Breed", targets: ["Breed"]),
  ],
  dependencies: [
    .package(
      name: "swift-composable-architecture",
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      .exact("0.24.0")
    ),
    .package(
      name: "NukeUI",
      url: "https://github.com/kean/NukeUI",
      .exact("0.6.7")
    )
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        "ApiClient", "Dogs", "Breed",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    .target(
      name: "ApiClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    .target(
      name: "Dogs",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    .target(
      name: "Breed",
      dependencies: [
        "Dogs",
        .product(name: "NukeUI", package: "NukeUI"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    
    // MARK - testTarget
    .testTarget(
      name: "AppTests",
      dependencies: [
        "App",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    .testTarget(
      name: "ApiClientTests",
      dependencies: [
        "App",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    
    .testTarget(
      name: "DogsTests",
      dependencies: [
        "Dogs",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
    
    .testTarget(
      name: "BreedTests",
      dependencies: [
        "Breed", "Dogs",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]),
  ]
)
