
import Foundation
import Moya
import Combine

enum YuHanApi {
    // 版本檢核
    case login(request: LoginRequest)
    case getOption(request: GetOptionRequest)
    case getToDoTasks(request: GetToDoTasksRequest)
    case updateTask(request: UpdateTaskRequest)
}

extension YuHanApi: TargetType {
    
    var baseURL: URL {
        return try! Configs.Network.serverUrl.asURL()
    }
    
    var path: String {
        switch self {
        case .login: return "api/Login"
        case .getOption: return "api/getOption"
        case .getToDoTasks: return "api/getToDoTasks"
        case .updateTask: return "api/updateTask"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login,
             .getOption,
             .getToDoTasks,
             .updateTask:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login,
             .getOption,
             .getToDoTasks,
             .updateTask:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: [String: Any]? {
        let params: [String: Any]?
        switch self {
        case .login(let request):
            params = request.parameters
        case .getOption(let request):
            params = request.parameters
        case .getToDoTasks(let request):
            params = request.parameters
        case .updateTask(let request):
            params = request.parameters
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login,
             .getOption,
             .getToDoTasks,
             .updateTask:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .login,
             .getOption,
             .getToDoTasks,
             .updateTask:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
    
    // test stubs data
    var sampleData: Data {
        let data: Data?
        switch self {
        case .login: data = Files.Json.Login
        case .getOption: data = Files.Json.GetOption
        case .getToDoTasks: data = Files.Json.GetToDoList
        case .updateTask: data = Files.Json.UpdateTask
        }
        return data ?? Data()
    }
}

struct UrichMaintainError: Error {
    let code: String
    var description: String?
}

struct YuHanApiError: Error {
    let code: String
    let description: String
    
    init(code: String, description: String) {
        self.code = code
        self.description = description
    }
    
    init(code: YuHanApiCode, description: String = "") {
        self.code = code.rawValue
        
        switch description.isEmpty {
        case true:  self.description = code.description
        case false: self.description = description
        }
    }
    
    var localizedDescription: String {
        return description
    }
}

extension YuHanApiError: LocalizedError {
    
    public var errorDescription: String? {
        return description
    }
}

enum YuHanApiCode: String, CaseIterable {
    
    case success           = "OK"
    case systemError       = "9999"
    
    var description: String {

        return ""
    }
}

struct BaseResponseError: Decodable {
    let field: String?
    let message: String?
}

typealias BaseResponseErrors = [BaseResponseError]

class BaseResponse<T: Decodable>: Decodable {
    
    var code: String?

    var message: String?

    var data: T?
    
    var errors: [BaseResponseError]?
    
    var rtCode: String {
        guard false == code?.isEmpty else {
            print("response has no code")
            return YuHanApiCode.systemError.rawValue
        }
        
        return code!
    }
    
    var msg: String {
        return message ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case code = "RetCode"
        case message = "RetMsg"
        case data = "Data"
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try? container.decode(String.self, forKey: .code)
        message = try? container.decode(String.self, forKey: .message)
        data = try? container.decode(T.self, forKey: .data)
    }
}
