
import Foundation

struct LoginResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct LoginResponse: ServerResponse {
    var status: EServerResponseStatus
    
    var data: LoginResponseData
    
}
