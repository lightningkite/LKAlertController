// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LKAlertController",
	platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "LKAlertController",
            targets: ["LKAlertController"]
        ),
    ],
    targets: [
        .target(
            name: "LKAlertController",
			path: "Pod/Classes"
		)
    ],
	swiftLanguageVersions: [.v5]
)
