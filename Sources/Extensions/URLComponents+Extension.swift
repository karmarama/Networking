import Foundation

extension URLComponents {
    var queryString: String {
         return query ?? ""
    }
}
