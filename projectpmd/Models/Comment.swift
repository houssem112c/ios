//
//  Comment.swift
//  projectpmd
//
//  Created by Mac-Mini-2021 on 18/11/2023.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String? // Rename from 'ids' to 'id'
    let lessonId: String?
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case lessonId
        case text
    }

}


