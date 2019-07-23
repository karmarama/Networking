//// Created by Nice Agency

import Foundation

extension String {
    func formEncode() -> String {
        let plussesReplaced = self.replacingOccurrences(of: "+", with: "%2B")
        let ampersandsReplaced = plussesReplaced.replacingOccurrences(of: "&", with: "%26")
        let spacesReplaced = ampersandsReplaced.replacingOccurrences(of: " ", with: "+")
        return spacesReplaced.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
