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
	dependencies: [
		.package(name: "Storable", path: "../Storable"),
		.package(url: "https://github.com/JohnSundell/Identity", from: "0.1.0")
	],
	targets: [
		.target(
			name: "Model",
			dependencies: [
				"Identity",
				"Storable"
			]
		),
		.testTarget(
			name: "ModelTests",
			dependencies: ["Model"]
		)
	]
)
