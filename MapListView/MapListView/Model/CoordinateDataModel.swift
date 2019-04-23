//
//  CoordinateDataModel.swift
//  MapListView
//
//  Created by Wesley on 4/22/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

struct CoordinateDataModel: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
