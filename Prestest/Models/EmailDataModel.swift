//
//  EmailDataModel.swift
//  Prestest
//
//  Created by Bosta Ginting on 16/10/20.
//

import Foundation
import UIKit

fileprivate typealias `Self` = DataEmail

struct DataEmail {
    
    var date: String?
    var email: String?
    var status: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case date = "date"
        case email = "message"
        case status = "status"
        
        var description: String {
            return self.rawValue
        }
    }
}

extension Self: Decodable {
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .date)
        email = try container.decode(String.self, forKey: .email)
        status = try container.decode(Int.self, forKey: .status)
    }
}

extension DataEmail {
    
    var convertedDate: Date {
        return dateFormatter.date(from: date ?? "") ?? Date()
    }
    
    private var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter
        }
}


