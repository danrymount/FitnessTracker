

import Foundation

enum LoginStatus
{
    case undefined
    case inProgress
    case success
    case failure
}

class LoginViewModel: ObservableObject {
    
    @Published var login: String = ""
    @Published var password: String = ""
    
    @Published private(set) var errorMsg: String = ""
    @Published private(set) var status: LoginStatus = .undefined
    
    func logIn() {
        
        repeat {
            if login.isEmpty
            {
                errorMsg = "Login is not specified"
                status = .failure
                break
            }
            
            if password.isEmpty
            {
                errorMsg = "Password is not specified"
                status = .failure
                break
            }
            
            errorMsg = ""
            self.status = .inProgress
            
            var act = LoginAction(parameters: LoginRequest(username: "name", password: "password"))
            
            act.call(completition: { response in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Auth.shared.setCredentials(accessToken: "1", refreshToken: "1")
                    self.status = .success
                    print(response)
                }
                
            })
            
            
        } while false
        
    }
}


struct LoginAction {
    
    var parameters: LoginRequest
    
    func call(completition: @escaping (LoginResponse) -> Void) {
        
        let request = ServerRequest(path: "/login", data: parameters)
        
        request.exec { error, data in
            
            var response = LoginResponse(status: error, accessToken: "", refreshToken: "")
            
            if data != nil
            {
                do {
                    var responseData = try JSONDecoder().decode(LoginResponse.self, from: data!)
                    print(responseData)
                } catch {
                    
                }
            }
            
            completition(response)
        }
    }
}
