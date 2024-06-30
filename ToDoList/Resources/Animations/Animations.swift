
import Foundation

struct Animations {
    struct Delay {
        static var ms500: DispatchTime {
            return .now() + 0.5
        }
    }
}
