
import Foundation

struct ServerRequest
{
    let path: String
    let data: Encodable
    
    func exec(completition: @escaping (EServerResponseStatus, Data?) -> Void)
    {
        // TODO move to some app constants
        let scheme: String = "http"
        let host: String = "192.168.0.140"
        let port = 4567
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.port = port
    

        guard let url = components.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            // Error: Unable to encode request parameters
        }

        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            var resErr: EServerResponseStatus = .success
            if error != nil {
                resErr = .failure
            }
            
            
            completition(resErr, data)
        }
        
        task.resume()
    }
}
