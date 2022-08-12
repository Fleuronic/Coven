// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "Presentation",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "Presentation",
			targets: [
				"Metrics",
				"Assets",
				"Styles"
			]
		)
	],
	dependencies: [
		.package(url: "https://github.com/Fleuronic/Metric.git", .branch("main")),
		.package(url: "https://github.com/Fleuronic/Telemetric.git", .branch("main"))
	],
	targets: [
		.target(
			name: "Metrics",
			dependencies: [
				"Metric"
			]
		),
		.target(
			name: "Assets",
			dependencies: [
				"Telemetric",
				"Metrics"
			],
			resources: [.process("Resources")]
		),
		.target(
			name: "Styles",
			dependencies: [
				"Telemetric",
				"Assets",
				"Metrics"
			]
		)
	]
)
