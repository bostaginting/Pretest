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
    
    private enum CodingKeys: String, CodingKey {
        
        case date = "date"
        case email = "message"
        
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
    }
}


