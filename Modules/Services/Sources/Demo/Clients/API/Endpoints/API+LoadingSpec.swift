// Copyright © Fleuronic LLC. All rights reserved.

import enum Demo.Demo
import protocol DemoService.LoadingSpec

extension API: LoadingSpec {
    public func loadDemos() async -> Demo.LoadingResult {
        do {
            try await Task.sleep(nanoseconds: .updateTime)
            return Bool.random() ? .success(Demo.allCases) : .failure(.loadError)
        } catch {
            return .failure(.sleepError(error))
        }
    }
}

public extension Demo {
    typealias LoadingResult = Swift.Result<[Demo], API.Error>
}

private extension UInt64 {
    static let updateTime: Self = 500_000_000
}
