
import Foundation
import Combine

protocol YuHanAPI {
    func login(request: LoginRequest) -> AnyPublisher<LoginResponse?, Error>
    func getOption(request: GetOptionRequest) -> AnyPublisher<GetOptionResponse?, Error>
    func getToDoLists(request: GetToDoTasksRequest) -> AnyPublisher<GetToDoTasksResponse?, Error>
    func updateTask(request: UpdateTaskRequest) -> AnyPublisher<UpdateTaskResponse?, Error>
}
