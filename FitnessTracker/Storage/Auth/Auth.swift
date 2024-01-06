
import Foundation


class Auth: ObservableObject {
    
    struct Credentials {
        var accessToken: String?
        var refreshToken: String?
    }

    @Token("accessToken")
    var accessToken: String?
    
    @Token("refreshToken")
    var refreshToken: String?
    
    static let shared: Auth = Auth()

    @Published var loggedIn: Bool = false
    
    private init() {
        loggedIn = hasAccessToken()
    }
    
    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        loggedIn = true
    }
    
    func hasAccessToken() -> Bool {
        return getCredentials().accessToken != nil
    }
    
    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }

    func getRefreshToken() -> String? {
        return getCredentials().refreshToken
    }

    func logout() {
        accessToken = nil
        refreshToken = nil
        
        loggedIn = false
    }
    
}
