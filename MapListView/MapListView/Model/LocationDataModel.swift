//
//  LocationDataModel.swift
//  MapListView
//
//  Created by Wesley on 4/22/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

struct LocationDataModel: Codable {
    var id: Int
    var city: String
    var coordinate: CoordinateDataModel
    var country: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case city = "name"
        case coordinate = "coord"
        case country
    }
}
