// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DogBreeds",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "DogBreeds",
      targets: ["DogBreeds"])
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
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "DogBreeds",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "NukeUI", package: "NukeUI")
      ]),
    .testTarget(
      name: "DogBreedsTests",
      dependencies: [
        "DogBreeds",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]),
  ]
)
