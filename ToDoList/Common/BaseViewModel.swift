
import Foundation
import Combine

class BaseViewModel {
    
    let provider: YuHanAPI
    @Published var isLoading = false
    
    var errorOccurredShowAlert = PassthroughSubject<Error?, Never>()
    
    init(provider: YuHanAPI) {
        self.provider = provider
    }

    deinit {
        print("\(type(of: self)): Deinited")
    }
}
