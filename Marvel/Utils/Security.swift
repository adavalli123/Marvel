import Foundation
import CryptoKit

struct Security { 
    /// reference - https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift
    static func md5Hash(timeStamp: Double) -> String {
        guard let data = (
            String(describing: timeStamp)
            + Person.aravind.privateKey
            + Person.aravind.publicKey
        ).data(using: .utf8)
        else { preconditionFailure("[\(self)] - invalid concatenatedKey") }
        
        return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
    }
}

enum Person: CaseIterable {
    case aravind
    case srikanth
}

extension Person {
    var publicKey: String {
        switch self {
        case .aravind:
            return "e5e56b34797627c785aeda89df54b247"
        case .srikanth:
            return "d5bf5e2aa998634e91902b49b6162f4a"
        }
    }
    
    var privateKey: String {
        switch self {
        case .aravind:
            return "e82cfc2204067fa3e231ab92a4c63599dfde5fd7"
        case .srikanth:
            return "e8152371d5a7c2f0e63cee716aeb7606c10783cd"
        }
    }

}
