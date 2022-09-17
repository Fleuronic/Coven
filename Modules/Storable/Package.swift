// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "Storable",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(
			name: "Storable",
			targets: ["Storable"]
		)
	],
	dependencies: [.package(url: "https://github.com/Fleuronic/Stores", .branch("keychain"))],
	targets: [
		.target(
			name: "Storable",
			dependencies: ["Stores"]
		)
	]
)
