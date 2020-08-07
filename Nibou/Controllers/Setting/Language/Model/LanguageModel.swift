//
//  LanguageModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 24/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct LanguageModel : Codable {
    let data : [LanguageData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([LanguageData].self, forKey: .data)
    }
    
}

struct LanguageData : Codable {
    let id : String?
    let type : String?
    let attributes : LanguageAttribute?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(LanguageAttribute.self, forKey: .attributes)
    }
}

struct LanguageAttribute : Codable {
    let active : Bool?
    let code : String?
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case code = "code"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
}
