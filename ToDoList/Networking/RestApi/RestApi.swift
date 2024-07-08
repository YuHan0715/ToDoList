
import UIKit
import Combine
import Moya

class RestApi: YuHanAPI {
    
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse?, Error> {
        return yuhanRequestObject(.login(request: request), type: LoginResponse.self)
    }
    
    func getOption(request: GetOptionRequest) -> AnyPublisher<GetOptionResponse?, Error> {
        return yuhanRequestObject(.getOption(request: request), type: GetOptionResponse.self)
    }
    
    func getToDoLists(request: GetToDoTasksRequest) -> AnyPublisher<GetToDoTasksResponse?, Error> {
        return yuhanRequestObject(.getToDoTasks(request: request), type: GetToDoTasksResponse.self)
    }
    
    func updateTask(request: UpdateTaskRequest) -> AnyPublisher<UpdateTaskResponse?, any Error> {
        return yuhanRequestObject(.updateTask(request: request), type: UpdateTaskResponse.self)
    }
    
    // 根據不然的站台使用不同的Provider
    var yuhanProvider: YuHanNetworking
    
    init(yuhanProvider: YuHanNetworking) {
        self.yuhanProvider = yuhanProvider
    }
}

extension RestApi {
    
    private func yuhanRequestObjectWithBaseResponse<T: Decodable>(_ target: YuHanApi, type: T.Type) -> AnyPublisher<BaseResponse<T>?, Error> {
        return yuhanProvider
                    .request(target, response: T.self)
                    .tryMap { response in
                        guard let apiCode = YuHanApiCode(rawValue: response.rtCode) else {
                            throw YuHanApiError(code: response.rtCode, description: response.msg)
                        }
                        
                        guard case .success = apiCode else {
                            throw YuHanApiError(code: apiCode.rawValue, description: response.msg)
                        }
                        
                        return response
                    }
                    .mapError { $0 }
                    .eraseToAnyPublisher()
    }
    
    private func yuhanRequestObject<T: Decodable>(_ target: YuHanApi, type: T.Type) -> AnyPublisher<T?, Error> {
        return yuhanRequestObjectWithBaseResponse(target, type: T.self)
            .tryMap { response in
                return response?.data
            }
            .eraseToAnyPublisher()
    }
}
