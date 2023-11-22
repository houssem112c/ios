import Foundation
enum UserRole: String, Codable {
    case contributor = "Contributeur"
    case organizer = "Organisateur"
    case admin = "Admin"
}

struct User: Codable, Identifiable {
    var id: String?
    var fullname: String
    var email: String
    var password: String
    var dateofbirth: Date
    var role: UserRole
    var profilepicture: String?
    var profilebio: String?
    var location: String?
    var facebooklink: String?
    var instagramlink: String?
    var linkedinlink: String?
    var phonenumber: Int?
    var isActive: Bool
    var isBanned: Bool
    var isVerified: Bool
    
    private enum CodingKeys: String, CodingKey {
            case id
            case fullname
            case email
            case password
            case dateofbirth
            case role
            case profilepicture
            case profilebio
            case location
            case facebooklink
            case instagramlink
            case linkedinlink
            case phonenumber
            case isActive
            case isBanned
            case isVerified
        }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Decode date using a DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateofbirth = try container.decode(Date.self, forKey: .dateofbirth)

            // Decode other properties
            id = try container.decodeIfPresent(String.self, forKey: .id)
            fullname = try container.decode(String.self, forKey: .fullname)
            email = try container.decode(String.self, forKey: .email)
            password = try container.decode(String.self, forKey: .password)
            role = try container.decode(UserRole.self, forKey: .role)
            profilepicture = try container.decodeIfPresent(String.self, forKey: .profilepicture)
            profilebio = try container.decodeIfPresent(String.self, forKey: .profilebio)
            location = try container.decodeIfPresent(String.self, forKey: .location)
            facebooklink = try container.decodeIfPresent(String.self, forKey: .facebooklink)
            instagramlink = try container.decodeIfPresent(String.self, forKey: .instagramlink)
            linkedinlink = try container.decodeIfPresent(String.self, forKey: .linkedinlink)
            phonenumber = try container.decodeIfPresent(Int.self, forKey: .phonenumber)
            isActive = try container.decode(Bool.self, forKey: .isActive)
            isBanned = try container.decode(Bool.self, forKey: .isBanned)
            isVerified = try container.decode(Bool.self, forKey: .isVerified)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            // Encode date using a DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            try container.encode(dateFormatter.string(from: dateofbirth), forKey: .dateofbirth)

            // Encode other properties
            try container.encodeIfPresent(id, forKey: .id)
            try container.encode(fullname, forKey: .fullname)
            try container.encode(email, forKey: .email)
            try container.encode(password, forKey: .password)
            try container.encode(role, forKey: .role)
            try container.encodeIfPresent(profilepicture, forKey: .profilepicture)
            try container.encodeIfPresent(profilebio, forKey: .profilebio)
            try container.encodeIfPresent(location, forKey: .location)
            try container.encodeIfPresent(facebooklink, forKey: .facebooklink)
            try container.encodeIfPresent(instagramlink, forKey: .instagramlink)
            try container.encodeIfPresent(linkedinlink, forKey: .linkedinlink)
            try container.encodeIfPresent(phonenumber, forKey: .phonenumber)
            try container.encode(isActive, forKey: .isActive)
            try container.encode(isBanned, forKey: .isBanned)
            try container.encode(isVerified, forKey: .isVerified)
        }
}

