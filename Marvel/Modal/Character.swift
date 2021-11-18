import Foundation

struct Character: Codable {
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let results: [Results]
}

// MARK: - Result
struct Results: Codable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
    let urls: [URLElement]
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}
