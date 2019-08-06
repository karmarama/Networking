import Foundation
@testable import Networking

struct URLSessionDataTaskLoaderFake: URLSessionDataTaskLoader {
    final class URLSessionDataTaskMock: URLSessionDataTask {
        override func resume() {
            return
        }
    }

    let data: Data?
    let response: URLResponse?
    let error: Error?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        DispatchQueue.main.async {
            completionHandler(self.data, self.response, self.error)
        }
        return URLSessionDataTaskMock()
    }
}
