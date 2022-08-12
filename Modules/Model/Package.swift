// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "Model",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "Model",
			targets: ["Model"]
		)
	],
	dependencies: [],
	targets: [
		.target(
			name: "Model",
			dependencies: []
		),
		.testTarget(
			name: "ModelTests",
			dependencies: ["Model"]
		)
	]
)
