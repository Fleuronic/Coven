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
		.package(name: "Models", path: "../Models"),
		.package(url: "https://github.com/Fleuronic/ErgoSwiftUI", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoDeclarativeUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/WorkflowContainers", branch: "main")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"Models",
				"Counter"
			]
		),
		.target(
			name: "Counter",
			dependencies: [
				"ErgoUIKit",
				"ErgoSwiftUI",
				"ErgoDeclarativeUIKit",
				"WorkflowContainers"
			]
		)
	]
)
