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
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.10.0")
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
				"WorkflowContainers"
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
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
			]
		),
		.testTarget(
			name: "CounterTests",
			dependencies: [
				"Counter",
				.product(name: "WorkflowTesting", package: "workflow-swift"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
			]
		)
	]
)
