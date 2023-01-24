// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Model",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Model",
			targets: ["Model"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/benspratling4/SwiftPhoneNumberFormatter", from: "3.0.0")
	],
	targets: [
		.target(
			name: "Model",
			dependencies: [
				"SwiftPhoneNumberFormatter"
			]
		),
		.testTarget(
			name: "ModelTests",
			dependencies: ["Model"]
		)
	]
)
