//
//  LocationCoordinator.swift
//  MapListView
//
//  Created by Wesley on 4/23/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

protocol LocationCoordinatorDelegate: class {
    func didGetLocations(_ locations: [LocationDataModel])
    func didFailGettingLocations(error: Error?)
}

class LocationCoordinator {
    
    weak var delegate: LocationCoordinatorDelegate?
    private var locationCache: LocationCacheInterface { return LocationCache.sharedInstance }
    
    private lazy var locationDataTasker: LocationDataTasker = {
        let dataTasker = LocationDataTasker()
        dataTasker.delegate = self
        return dataTasker
    }()
    
    func getLocations() {
        // Get all locations
        locationDataTasker.getLocations()
    }
    
    private func setLocations(_ locations: [LocationDataModel]) {
        // Run this on a background thread since it could be load intensive
        DispatchQueue.global(qos: .background).async { [weak self] in
            // Set all locations in cache
            self?.locationCache.setLocations(locations)
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didGetLocations(locations)
            }
        }
    }
}

// MARK: - LocationDataTaskerDelegate -
extension LocationCoordinator: LocationDataTaskerDelegate {
    func didGetLocations(_ locations: [LocationDataModel]) {
        setLocations(locations)
    }
    
    func didFailGettingLocations(error: Error?) {
        delegate?.didFailGettingLocations(error: error)
    }
}
