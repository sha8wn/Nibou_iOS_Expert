
import Foundation

struct EarningMonthModel : Codable {
    let data : [PaymentOverallData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([PaymentOverallData].self, forKey: .data)
    }
}

struct DashboardOverallModel : Codable {
    let data : PaymentOverallData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(PaymentOverallData.self, forKey: .data)
    }
}

struct PaymentOverallData : Codable {
    let type : String?
    let attributes : PaymentOverallAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(PaymentOverallAttributes.self, forKey: .attributes)
    }
    
}

struct PaymentOverallAttributes : Codable {
    let total_seconds : Double?
    let date_at: String?
    let amount : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case total_seconds = "total_seconds"
        case amount = "amount"
        case date_at = "date_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_seconds = try values.decodeIfPresent(Double.self, forKey: .total_seconds)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        date_at = try values.decodeIfPresent(String.self, forKey: .date_at)
    }
    
}

