

import Foundation

enum LoginStatus
{
    case undefined
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
                break
            }
            
            if password.isEmpty
            {
                errorMsg = "Password is not specified"
                break
            }
            
            // TODO send request
            errorMsg = ""
            status = .success
        } while false
    }
}
