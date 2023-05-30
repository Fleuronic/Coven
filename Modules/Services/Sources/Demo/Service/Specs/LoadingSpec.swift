public protocol LoadingSpec {
    associatedtype DemoLoadingResult
    
    func loadDemos() async -> DemoLoadingResult
}
