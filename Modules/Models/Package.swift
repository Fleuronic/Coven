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
		),
		.library(
			name: "Textbelt",
			targets: ["Textbelt"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/benspratling4/SwiftPhoneNumberFormatter", from: "3.0.0")
	],
	targets: [
		.target(
			name: "Coven",
			dependencies: [
				"SwiftPhoneNumberFormatter"
			]
		),
		.target(
			name: "Textbelt",
			dependencies: []
		),
		.testTarget(
			name: "CovenTests",
			dependencies: ["Coven"]
		),
		.testTarget(
			name: "TextbeltTests",
			dependencies: ["Textbelt"]
		)
	]
)
