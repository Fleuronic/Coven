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
			name: "Main",
			targets: ["Main"]
		),
		.library(
			name: "Authentication",
			targets: ["Authentication"]
		)
	],
	dependencies: [
		.package(name: "Services", path: "../Services"),
		.package(name: "Presentation", path: "../Presentation"),
		.package(url: "https://github.com/square/workflow-swift", from: "1.0.0-rc.1"),
		.package(url: "https://github.com/Fleuronic/WorkflowContainers", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Ergo", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Geometric", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Telemetric", branch: "main")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"Main",
				"Authentication"
			]
		),
		.target(
			name: "Main",
			dependencies: [
				"Geometric",
				"Ergo",
				"Presentation",
				"WorkflowContainers"
			]
		),
		.target(
			name: "Authentication",
			dependencies: [
				"Geometric",
				"Telemetric",
				"Ergo",
				"Presentation",
				"WorkflowContainers",
				.product(name: "CovenService", package: "Services"),
				.product(name: "TextbeltService", package: "Services")
			]
		),
		.testTarget(
			name: "RootTests",
			dependencies: [
				"Root",
				.product(name: "WorkflowTesting", package: "workflow-swift"),
			]
		)
	]
)
