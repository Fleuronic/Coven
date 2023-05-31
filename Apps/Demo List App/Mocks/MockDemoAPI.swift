// Copyright © Fleuronic LLC. All rights reserved.

import enum Demo.Demo
import protocol DemoService.LoadingSpec

struct MockDemoAPI: LoadingSpec {
	let result: () -> Demo.LoadingResult
	
	init(result: @autoclosure @escaping () -> Demo.LoadingResult) {
		self.result = result
	}
	
	func loadDemos() async -> Demo.LoadingResult {
		try! await Task.sleep(nanoseconds: .updateTime)
		return result()
	}
}

// MARK: -
private extension UInt64 {
	static let updateTime: Self = 500_000_000
}
