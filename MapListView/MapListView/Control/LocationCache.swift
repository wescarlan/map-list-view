//
//  LocationCache.swift
//  MapListView
//
//  Created by Wesley on 4/22/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

protocol LocationCacheInterface: class {
    var allLocations: [LocationDataModel] { get }
    var filteredLocations: [LocationDataModel] { get }
    func setLocations(_ locations: [LocationDataModel])
    func filterLocations(searchTerm: String)
}

class LocationCache: LocationCacheInterface {
    
    static var sharedInstance = LocationCache()
    
    var allLocations: [LocationDataModel] = []
    var filteredLocations: [LocationDataModel] = []
    
    private var prefixTree: PrefixNode?
    
    func setLocations(_ locations: [LocationDataModel]) {
        allLocations = locations
        filteredLocations = locations
        prefixTree = PrefixNode(size: locations.count)
        for i in 0...locations.count-1 {
            let location = locations[i]
            prefixTree?.update(index: i, prefix: location.city)
        }
    }
    
    func filterLocations(searchTerm: String) {
        guard let locationRange = prefixTree?.find(prefix: searchTerm) else {
            filteredLocations = []
            return
        }
        filteredLocations = Array(allLocations[locationRange])
    }
}
