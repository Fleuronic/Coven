// swift-tools-version:5.7
import PackageDescription

let package = Package(
	name: "Features",
	platforms: [
		.iOS(.v16)
	],
	products: [
		.library(
			name: "Root",
			targets: ["Root"]
		),
		.library(
			name: "DemoList",
			targets: ["DemoList"]
		),
		.library(
			name: "Counter",
			targets: ["Counter"]
		)
	],
	dependencies: [
		.package(name: "Demo", path: "../Models"),
		.package(url: "https://github.com/Fleuronic/ErgoSwiftUI", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/ErgoDeclarativeUIKit", branch: "main"),
		.package(url: "https://github.com/Fleuronic/WorkflowContainers", branch: "main"),
		.package(url: "https://github.com/square/workflow-swift", from: "1.0.0"),
		.package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.3.1"),
		.package(url: "https://github.com/nalexn/ViewInspector", branch: "0.9.7"),
		.package(url: "https://github.com/SlaunchaMan/ErrorAssertions.git", from: "0.2.0")
	],
	targets: [
		.target(
			name: "Root",
			dependencies: [
				"DemoList",
				"Counter"
			]
		),
		.target(
			name: "DemoList",
			dependencies: [
				"Demo",
				"ErgoSwiftUI",
				"WorkflowContainers"
			]
		),
		.target(
			name: "Counter",
			dependencies: [
				"Demo",
				"ErgoUIKit",
				"ErgoSwiftUI",
				"ErgoDeclarativeUIKit",
				"WorkflowContainers",
				.product(name: "ErrorAssertions", package: "ErrorAssertions")
			]
		),
		.testTarget(
			name: "RootTests",
			dependencies: [
				"Root",
				.product(name: "WorkflowTesting", package: "workflow-swift")
			]
		),
		.testTarget(
			name: "DemoListTests",
			dependencies: [
				"DemoList",
				"ViewInspector",
				.product(name: "Introspect", package: "SwiftUI-Introspect"),
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				.product(name: "ErgoSwiftUITesting", package: "ErgoSwiftUI")
			]
		),
		.testTarget(
			name: "CounterTests",
			dependencies: [
				"Counter",
				"ViewInspector",
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				.product(name: "ErgoSwiftUITesting", package: "ErgoSwiftUI"),
				.product(name: "ErgoUIKitTesting", package: "ErgoUIKit"),
				.product(name: "ErgoDeclarativeUIKitTesting", package: "ErgoUIKit"),
				.product(name: "ErrorAssertionExpectations", package: "ErrorAssertions")
			]
		)
	]
)
