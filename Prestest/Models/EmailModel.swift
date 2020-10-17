//
//  EmailModel.swift
//  Prestest
//
//  Created by Bosta Ginting on 16/10/20.
//

import Foundation
import UIKit

fileprivate typealias `Self` = EmailModelResponse

struct EmailModelResponse {
    
    var dataEmail : [DataEmail]?
    
    private enum CodingKeys: String, CodingKey {
        case dataEmail = "data"
        
        var description: String {
            return self.rawValue
        }
    }
}

extension Self: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dataEmail = try container.decodeIfPresent([DataEmail].self, forKey: .dataEmail)
    }
}
