

import Foundation

enum RegistrationStatus {
    case undefined
    case inProgress
    case success
    case failure
}

class RegistrationViewModel: ObservableObject {
    
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    
    @Published private(set) var status: RegistrationStatus = .undefined
    @Published private(set) var errorMsg: String = ""
    
    
    func register() {
        repeat {
            if login.isEmpty
            {
                errorMsg = "Login is not specified"
                break
            }
            
            if password.isEmpty
            {
                errorMsg = "Password is not specified"
                break
            }
            
            if password != confirmPassword
            {
                errorMsg = "Passwords doesn't match"
                break
            }
            
            var act = RegisterAction(parameters: RegistrationRequest(username: "name", password: "password", name: name))
            
            status = .inProgress
            
            act.call(completition: { response in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if response.status == .success
                    {
                        self.status = .success
                    }
                    else
                    {
                        self.status = .failure
                        self.errorMsg = "Server failure"
                    }
                }
                
            })
        }
        while false
    }
}

struct RegisterAction {
    
    var parameters: RegistrationRequest
    
    func call(completition: @escaping (RegistrationResponse) -> Void) {
        
        let request = ServerRequest(path: "/register", data: parameters)
        
        request.exec { error, data in
            var response = RegistrationResponse(status: error)
            
            completition(response)
        }
    }
}
