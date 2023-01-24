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
			name: "Authentication",
			targets: ["Authentication"]
		),
		.library(
			name: "Todo",
			targets: ["Todo"]
		)
	],
	dependencies: [
		.package(name: "Model", path: "../Model"),
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
				"WorkflowContainers",
				"Todo",
				"Authentication"
			]
		),
		.testTarget(
			name: "RootTests",
			dependencies: [
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				"Root"
			]
		),
		.target(
			name: "Authentication",
			dependencies: [
				"Ergo",
				"Geometric",
				"Telemetric",
				"Model",
				"Services",
				"Presentation",
				"WorkflowContainers"
			]
		),
		.testTarget(
			name: "AuthenticationTests",
			dependencies: [
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				"Authentication"
			]
		),
		.target(
			name: "Todo",
			dependencies: [
				"Ergo",
				"WorkflowContainers",
				"Geometric",
				"Telemetric",
				"Model",
				"Presentation"
			]
		),
		.testTarget(
			name: "TodoTests",
			dependencies: [
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				"Todo"
			]
		)
	]
)
