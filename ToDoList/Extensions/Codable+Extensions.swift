
import Foundation

extension Encodable {
    var parameters: [String: Any]? {
        
        if let data = try? JSONEncoder().encode(self), let params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]? {
            return params
        }
        
        return nil
    }
}
