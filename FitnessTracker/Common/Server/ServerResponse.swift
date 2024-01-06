

import Foundation


enum EServerResponseStatus: Decodable
{
    case success
    case failure
}

protocol ServerResponse: Decodable {
    var status: EServerResponseStatus { get }
}
