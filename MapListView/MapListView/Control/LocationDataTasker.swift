//
//  LocationDataTasker.swift
//  MapListView
//
//  Created by Wesley on 4/23/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

protocol LocationDataTaskerDelegate: class {
    func didGetLocations(_ locations: [LocationDataModel])
    func didFailGettingLocations(error: Error?)
}

class LocationDataTasker {
    
    struct LocationFile {
        static let name = "locations"
        static let type = "json"
    }
    
    weak var delegate: LocationDataTaskerDelegate?
    private lazy var decoder = JSONDecoder()
    
    func getLocations() {
        guard let fileUrl = Bundle.main.url(forResource: LocationFile.name, withExtension: LocationFile.type) else {
            delegate?.didFailGettingLocations(error: nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            let locations = try decoder.decode([LocationDataModel].self, from: data)
            delegate?.didGetLocations(locations)
        } catch {
            delegate?.didFailGettingLocations(error: error)
        }
    }
}
