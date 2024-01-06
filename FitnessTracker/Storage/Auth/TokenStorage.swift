
import Foundation
import SwiftUI


public extension SecureStorage {
    func addToken(_ value: String, for key: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key
        query[kSecValueData] = value.data(using: .utf8)
        
        do {
            try addItem(query: query)
        } catch {
            return
        }
    }
    
    func updateToken(_ value: String, for key: String) {
        guard let _ = getToken(for: key) else {
            addToken(value, for: key)
            return
        }
        
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key
        
        var attributesToUpdate: [CFString: Any] = [:]
        attributesToUpdate[kSecValueData] = value.data(using: .utf8)
        
        do {
            try updateItem(query: query, attributesToUpdate: attributesToUpdate)
        } catch {
            return
        }
    }
    
    func getToken(for key: String) -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key
        
        var result: [CFString: Any]?
        
        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }
        
        if let data = result?[kSecValueData] as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func deleteToken(for key: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key
        
        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
}


@propertyWrapper
public struct Token: DynamicProperty {
    private let key: String
    private let storage = SecureStorage()
    
    public init(_ key: String) {
        self.key = key
    }
    
    public var wrappedValue: String? {
        get { storage.getToken(for: key) }
        nonmutating set {
            if let newValue {
                storage.updateToken(newValue, for: key)
            } else {
                storage.deleteToken(for: key)
            }
        }
    }
}
