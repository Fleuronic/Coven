// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Presentation",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Presentation",
			targets: [
				"Metrics",
				"Assets",
				"Elements"
			]
		)
	],
	dependencies: [
		.package(name: "Models", path: "../Models"),
		.package(url: "https://github.com/Fleuronic/Metric.git", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Telemetric.git", branch: "main")
	],
	targets: [
		.target(
			name: "Metrics",
			dependencies: ["Metric"]
		),
		.target(
			name: "Assets",
			dependencies: [
				"Metrics",
				"Telemetric"
			],
			resources: [.process("Resources")]
		),
		.target(
			name: "Elements",
			dependencies: [
				"Metrics",
				"Assets",
				.product(name: "Coven", package: "Models")
			]
		)
	]
)
