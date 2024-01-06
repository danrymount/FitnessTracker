
import Foundation


struct LoginResponse: ServerResponse {
    var status: EServerResponseStatus
    
    let accessToken: String
    let refreshToken: String
}
