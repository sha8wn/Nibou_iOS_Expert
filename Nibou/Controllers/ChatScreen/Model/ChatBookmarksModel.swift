//
//  ChatBookmarksModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct ChatBookmarksModel : Codable {
    
    let data : [ChatBookmarksData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ChatBookmarksData].self, forKey: .data)
    }
    
}

struct ChatBookmarksData : Codable {
    let id : String?
    let type : String?
    let attributes : ChatBookmarksAttributes?
//    let relationships : ChatBookmarksRelationships?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
//        case relationships = "relationships"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ChatBookmarksAttributes.self, forKey: .attributes)
//        relationships = try values.decodeIfPresent(ChatBookmarksRelationships.self, forKey: .relationships)
    }
    
}

struct ChatBookmarksAttributes : Codable {
    let text : String?
    let user_id : Int?
    let customer_id: Int?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case text = "text"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case customer_id = "customer_id"
    }
    
 
}

struct ChatBookmarksRelationships : Codable {
    let room : ChatBookmarksRoom?
    let message : ChatBookmarksMessage?
    
    enum CodingKeys: String, CodingKey {
        
        case room = "room"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room = try values.decodeIfPresent(ChatBookmarksRoom.self, forKey: .room)
        message = try values.decodeIfPresent(ChatBookmarksMessage.self, forKey: .message)
    }
    
}

struct ChatBookmarksMessage : Codable {
    let data : Data?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
    
}

struct ChatBookmarksRoom : Codable {
    let data : Data?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
    
}

