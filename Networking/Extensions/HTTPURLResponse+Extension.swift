import Foundation

extension HTTPURLResponse {
    public var isSuccessful: Bool {
        return (100...399).contains(statusCode)
    }

    public var isError: Bool {
        return (400...599).contains(statusCode)
    }
}
