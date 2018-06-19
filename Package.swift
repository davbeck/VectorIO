// swift-tools-version:4.0
import PackageDescription

let package = Package(
	name: "VectorIO",
	products: [
		.executable(name: "vectorio", targets: ["VectorIOCLI"]),
		.library(name: "VectorIO", targets: ["VectorIO"]),
		.library(name: "VectorIOCodeGen", targets: ["VectorIOCodeGen"]),
	],
	targets: [
		.target(
			name: "VectorIOCLI",
			dependencies: [
				"VectorIOCodeGen",
				"VectorIO",
			]
		),
		.target(
			name: "VectorIO",
			dependencies: [
			]
		),
		.testTarget(
			name: "VectorIOTests",
			dependencies: ["VectorIO"]
		),
		.target(
			name: "VectorIOCodeGen",
			dependencies: [
				"VectorIO",
			]
		),
		.testTarget(
			name: "VectorIOCodeGenTests",
			dependencies: [
				"VectorIOCodeGen",
				"VectorIO",
			]
		),
	]
)
