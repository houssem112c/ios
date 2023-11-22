import Foundation

struct Lesson: Codable, Identifiable {
    var id: String?
    var name: String
    var description: String
    var isFavorite: Bool // Add this property

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case isFavorite

    }
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.id == rhs.id
    }
}
struct ResponseModel: Decodable {
    let message: String
    let list: [Lesson]
}
