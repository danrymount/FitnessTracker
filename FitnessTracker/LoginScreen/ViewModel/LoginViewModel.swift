

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
        if login.isEmpty
        {
            errorMsg = "Login is not specified"
            status = .failure
            return
        }
        
        if password.isEmpty
        {
            errorMsg = "Password is not specified"
            status = .failure
            return
        }
        
        errorMsg = ""
        self.status = .inProgress
        
        let act = LoginAction(parameters: LoginRequest(username: login, password: password))
        
        act.call(completition: { response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // TODO handle server response, remove mock auth info
                Auth.shared.setCredentials(accessToken: response.data.accessToken, refreshToken: response.data.refreshToken)
                self.status = .success
                print(response)
            }
            
        })
    }
}


struct LoginAction {
    
    var parameters: LoginRequest
    
    func call(completition: @escaping (LoginResponse) -> Void) {
        
        let request = ServerRequest(path: "/login", data: parameters)
        
        request.exec { error, data in
            
            var response = LoginResponse(status: error, data: LoginResponseData(accessToken: "", refreshToken: ""))
            
            if let respData = data
            {
                do {
                    response.data = try JSONDecoder().decode(LoginResponseData.self, from: respData)
                } catch {
                    
                }
            }
            
            completition(response)
        }
    }
}
