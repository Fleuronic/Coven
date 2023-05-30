public extension API {
    enum Error: Swift.Error {
        case loadError
        case sleepError(Swift.Error)
    }
}
