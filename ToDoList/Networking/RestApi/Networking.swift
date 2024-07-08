
import Foundation
import Moya
import Combine
import Alamofire

class OnlineProvider<Target> where Target: Moya.TargetType {
    fileprivate let online: AnyPublisher<Bool, Never>
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: AnyPublisher<Bool, Never> = connectedToInternet()) {
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }

    func request(_ token: Target) -> AnyPublisher<Moya.Response, MoyaError> {
        let actualRequest = provider.requestPublisher(token, callbackQueue: DispatchQueue.main)
        // Fallback on earlier versions
        return online
            .filter({ $0 })  // Wait until we're online
            .prefix(1)        // Take 1 to make sure we only invoke the API once.
            .setFailureType(to: MoyaError.self) // this is required for iOS 13
            .flatMap({ _ in  // Turn the online state into a network request
                return actualRequest
                    .filterSuccessfulStatusCodes()
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: OnlineProvider<T> { get }

    static func defaultNetworking() -> Self
    static func stubbingNetworking() -> Self
}

extension NetworkingType {
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)

            // Sign all non-XApp, non-XAuth token requests
            return endpoint
        }
    }

    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }

    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        if Configs.Network.loggingEnabled == true {
            plugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)))
        }
        return plugins
    }

    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest() // endpoint.urlRequest
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

enum NetworkingError: Error {
    case statusCode(code: Int)
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .statusCode(let code):
            return String(format: i18n.Api.Error_StatusCode, code)
        }
    }
}

struct YuHanNetworking: NetworkingType {
    typealias T = YuHanApi
    let provider: OnlineProvider<T>

    var m_bIsNeedRefreshToken: Bool = false
    var m_bIsTokenRefreshing: Bool = false
    
    static func defaultNetworking() -> Self {
        return YuHanNetworking(provider: newProvider(plugins, networking: self))
    }
    
    static func stubbingNetworking() -> Self {
        return YuHanNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(),
                                                       requestClosure: YuHanNetworking.endpointResolver(),
                                                       stubClosure: MoyaProvider.immediatelyStub,
                                                       online: Just(true).eraseToAnyPublisher()))
    }
    
    func request<Response: Decodable>(_ request: T, response: Response.Type) -> AnyPublisher<BaseResponse<Response>, Error> {
        print("APISEND \(request.path)")
        print("Request:\n\(request.parameters)")
        let actualRequest = self.provider
            .request(request)
            .map(BaseResponse<Response>.self)
            .mapError({ error -> Error in
                
                guard case let .statusCode(response) = error else {
                    return error
                }
                
                guard let baseResponse = try? response.map(BaseResponse<Response>.self) else {
                    return NetworkingError.statusCode(code: response.statusCode)
                }
                
                return NetworkingError.statusCode(code: response.statusCode)

            })
            .eraseToAnyPublisher()
        return actualRequest
    }
}

private func newProvider<T, U: NetworkingType>(_ plugins: [PluginType], networking: U.Type, xAccessToken: String? = nil) -> OnlineProvider<T> where T: TargetType {
    return OnlineProvider(endpointClosure: networking.endpointsClosure(xAccessToken),
                          requestClosure: networking.endpointResolver(),
                          stubClosure: networking.APIKeysBasedStubBehaviour,
                          plugins: plugins)
}
