// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Models",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Coven",
			targets: ["Coven"]
		)
	],
	targets: [
		.target(
			name: "Coven"
		),
		.testTarget(
			name: "CovenTests",
			dependencies: ["Coven"]
		)
	]
)
