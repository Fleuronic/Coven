// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Services",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "CovenService",
			targets: [
				"CovenService",
				"CovenAPI",
				"CovenDatabase"
			]
		),
		.library(
			name: "TextbeltService",
			targets: [
				"TextbeltService",
				"TextbeltAPI"
			]
		)
	],
	dependencies: [
		.package(name: "Models", path: "../Models"),
		.package(url: "https://github.com/Fleuronic/Catenoid", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Catenary", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Caesura", branch: "main")
	],
	targets: [
		.target(
			name: "CovenService",
			dependencies: [
				"Catenary",
				"Catenoid",
				.product(name: "Coven", package: "Models")
			],
			path: "Sources/Coven/Service"
		),
		.target(
			name: "CovenAPI",
			dependencies: [
				"Caesura",
				"CovenService"
			],
			path: "Sources/Coven/Clients/API"
		),
		.target(
			name: "CovenDatabase",
			dependencies: [
				"Catenoid",
				"CovenService"
			],
			path: "Sources/Coven/Clients/Database"
		),
		.target(
			name: "TextbeltService",
			dependencies: [
				"Catenary",
				.product(name: "Textbelt", package: "Models")
			],
			path: "Sources/Textbelt/Service"
		),
		.target(
			name: "TextbeltAPI",
			dependencies: [
				"Catenary",
				"TextbeltService"
			],
			path: "Sources/Textbelt/Clients/API"
		),
	]
)
