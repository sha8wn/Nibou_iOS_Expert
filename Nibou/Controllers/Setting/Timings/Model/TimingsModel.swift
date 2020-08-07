//
//  TimingsModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 23/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct TimingsModel : Codable {
    
    let data : [TimingsData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([TimingsData].self, forKey: .data)
    }
    
}

struct TimingsData : Codable {
    let id : String?
    let type : String?
    let attributes : TimingsAttributes?
    //    let relationships : Relationships?
    
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
        attributes = try values.decodeIfPresent(TimingsAttributes.self, forKey: .attributes)
        //        relationships = try values.decodeIfPresent(Relationships.self, forKey: .relationships)
    }
    
}

struct TimingsAttributes : Codable {
    let day_number : Int?
    let time_from : String?
    let time_to : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case day_number = "day_number"
        case time_from = "time_from"
        case time_to = "time_to"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day_number = try values.decodeIfPresent(Int.self, forKey: .day_number)
        time_from = try values.decodeIfPresent(String.self, forKey: .time_from)
        time_to = try values.decodeIfPresent(String.self, forKey: .time_to)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}
