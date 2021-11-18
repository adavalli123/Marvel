import Foundation

public enum EndPoint: Hashable {
    case characters(offset: Int)
    case character(id: String)
}

extension EndPoint {
    public var base: String { "https://gateway.marvel.com/v1/public/" }
    
    var path: String {
        switch self {
        case .characters(let offset):
            return fullPath(base + "characters", offset: offset)
        case .character(let id):
            return fullPath(base + "character/\(id)")
        }
    }
    
    private func fullPath(_ path: String, offset: Int = 0) -> String {
        let timeStamp = Date.timeIntervalSinceReferenceDate
        if offset == 0 {
            return "\(path)?ts=\(timeStamp)&apikey=\(Person.aravind.publicKey)&hash=\(Security.md5Hash(timeStamp: timeStamp))&limit=50"
        }
        return "\(path)?ts=\(timeStamp)&apikey=\(Person.aravind.publicKey)&hash=\(Security.md5Hash(timeStamp: timeStamp))&limit=50&offset=\(offset)"
    }
}
