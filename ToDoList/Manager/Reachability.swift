
import Foundation
import Combine
import Alamofire

func connectedToInternet() -> AnyPublisher<Bool, Never> {
    
    return ReachabilityManager.shared.publisher(for: \.reach).eraseToAnyPublisher()
}

private class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    @objc dynamic var reach: Bool = false

    override init() {
        super.init()

        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.reach = false
            case .reachable:
                self.reach = true
            case .unknown:
                self.reach = false
            }
        })
    }
}
