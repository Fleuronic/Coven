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
		)
	]
)
