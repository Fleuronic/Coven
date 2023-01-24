// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Services",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Services",
			targets: ["Coven"]
		)
	],
	dependencies: [
		.package(name: "Model", path: "../Model"),
		.package(url: "https://github.com/Fleuronic/Catenoid", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Catenary", branch: "main"),
	],
	targets: [
		.target(
			name: "Coven",
			dependencies: [
				"Model",
				"Catenoid",
				"Catenary"
			]
		)
	]
)
