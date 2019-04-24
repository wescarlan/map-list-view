//
//  LocationCache.swift
//  MapListView
//
//  Created by Wesley on 4/22/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

protocol LocationCacheInterface: class {
    // Get a list of the filtered locations - returns all locations if no search filter
    var filteredLocations: [LocationDataModel] { get }
    // Set the list of locations
    func setLocations(_ locations: [LocationDataModel])
    // Filter locations by a search term
    func filterLocations(searchTerm: String)
}

class LocationCache: LocationCacheInterface {
    
    static var sharedInstance = LocationCache()
    
    var allLocations: [LocationDataModel] = []
    var filteredLocations: [LocationDataModel] = []
    
    private var prefixTree: PrefixNode?
    
    func setLocations(_ locations: [LocationDataModel]) {
        // Sort the locations in alphabetical order by city
        let sortedLocations = locations.sorted(by: {
            return $0.city.lowercased() < $1.city.lowercased()
        })
        setSortedLocations(sortedLocations)
    }
    
    private func setSortedLocations(_ locations: [LocationDataModel]) {
        allLocations = locations
        filteredLocations = locations
        
        // Create a prefix tree for the locations' cities
        // This allows us to have O(k) lookup where k is the length of the largest city name
        prefixTree = PrefixNode(size: locations.count)
        for i in 0 ..< locations.count {
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
