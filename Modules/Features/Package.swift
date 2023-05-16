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
		.package(url: "https://github.com/Fleuronic/Ergo", branch: "main"),
		.package(url: "https://github.com/Fleuronic/WorkflowContainers", branch: "main")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"Counter"
			]
		),
		.target(
			name: "Counter",
			dependencies: [
				"Ergo",
				"WorkflowContainers",
			]
		)
	]
)
