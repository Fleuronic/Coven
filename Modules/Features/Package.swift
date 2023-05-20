// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Features",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Root",
			targets: ["Root"]
		),
		.library(
			name: "Counter",
			targets: ["Counter"]
		)
	],
	dependencies: [
		.package(name: "Demo", path: "../Models"),
		.package(url: "https://github.com/Fleuronic/ErgoSwiftUI", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoDeclarativeUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/WorkflowContainers", branch: "main")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"Demo",
				"Counter"
			]
		),
		.target(
			name: "Counter",
			dependencies: [
				"Demo",
				"ErgoUIKit",
				"ErgoSwiftUI",
				"ErgoDeclarativeUIKit",
				"WorkflowContainers"
			]
		),
		.testTarget(
			name: "RootTests",
			dependencies: ["Root"]
		),
		.testTarget(
			name: "CounterTests",
			dependencies: ["Counter"]
		)
	]
)
