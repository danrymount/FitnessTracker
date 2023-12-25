

import Foundation

enum RegistrationStatus {
    case undefined
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
            
            // TODO send request
            
            status = .success
        }
        while false
    
        // TODO
    }
}
