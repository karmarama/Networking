// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Networking",
    products: [
        .library(name: "Networking", targets: ["Networking"])
    ],
    targets: [
        .target(
            name: "Networking",
            path: "Sources"
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "NetworkingTests"
        )
    ]
)
