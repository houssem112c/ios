import Foundation
/*
struct Event: Codable, Identifiable {
    var id: String?
    var eventName: String
    var eventDate: Date
    var textwhats: String
    var eventLocation: String
    var eventDescription: String
    var imageURL: String? // Champ pour l'URL de l'image

  
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case eventName
        case eventDate
        case textwhats
        case eventLocation
        case eventDescription
        case imageURL // Ajout du champ pour l'URL de l'image dans les clés de codage

    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}*/
struct Event: Codable, Identifiable {
    var id: String?
    let eventName: String
    let eventDate: Date
    let textwhats: String
    let eventLocation: String
    let eventDescription: String
    let imageURL: String // Assurez-vous que la clé pour l'image correspond exactement à celle dans votre JSON
    var isFavorites: Bool // Add this property

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case eventName
        case eventDate
        case textwhats
        case eventLocation
        case eventDescription
        case imageURL // Assurez-vous que la clé pour l'image correspond exactement à celle dans votre JSON
        case isFavorites

    }
}
