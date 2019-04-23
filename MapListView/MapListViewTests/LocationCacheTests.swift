//
//  LocationCacheTests.swift
//  MapListViewTests
//
//  Created by Wesley on 4/19/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import XCTest

class LocationCacheTests: XCTestCase {
    
    var locationCache: LocationCache!
    
    var mockLocations: [LocationDataModel] = [
        LocationDataModel(id: 0, city: "A", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 1, city: "a", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 2, city: "Ab", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 3, city: "Abc", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 4, city: "A b", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 5, city: "A-b", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 6, city: "B", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 7, city: "C", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: ""),
        LocationDataModel(id: 8, city: "", coordinate: CoordinateDataModel(latitude: 0, longitude: 0), country: "")
    ]
    
    override func setUp() {
        super.setUp()
        locationCache = LocationCache()
        locationCache.setLocations(mockLocations)
    }
    
    func testSetLocations() {
        XCTAssertEqual(locationCache.allLocations.count, mockLocations.count)
        XCTAssertEqual(locationCache.allLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.allLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.allLocations[2].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.allLocations[3].id, mockLocations[3].id)
        XCTAssertEqual(locationCache.allLocations[4].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.allLocations[5].id, mockLocations[5].id)
        XCTAssertEqual(locationCache.allLocations[6].id, mockLocations[6].id)
        XCTAssertEqual(locationCache.allLocations[7].id, mockLocations[7].id)
        XCTAssertEqual(locationCache.allLocations[8].id, mockLocations[8].id)
        
        XCTAssertEqual(locationCache.filteredLocations.count, mockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[6].id, mockLocations[6].id)
        XCTAssertEqual(locationCache.filteredLocations[7].id, mockLocations[7].id)
        XCTAssertEqual(locationCache.filteredLocations[8].id, mockLocations[8].id)
    }
    
    func testSearchEmptyString() {
        locationCache.filterLocations(searchTerm: "")
        
        XCTAssertEqual(locationCache.filteredLocations.count, mockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations.count, mockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[6].id, mockLocations[6].id)
        XCTAssertEqual(locationCache.filteredLocations[7].id, mockLocations[7].id)
        XCTAssertEqual(locationCache.filteredLocations[8].id, mockLocations[8].id)
    }
    
    func testSearchInvalidCharacter() {
        locationCache.filterLocations(searchTerm: "x")
        XCTAssertTrue(locationCache.filteredLocations.isEmpty)
    }
    
    func testSearchValidUppercaseCharacter() {
        locationCache.filterLocations(searchTerm: "A")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 6)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[5].id)
    }
    
    func testSearchValidLowercaseCharacter() {
        locationCache.filterLocations(searchTerm: "a")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 6)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[5].id)
    }
    
    func testSearchInvalidString() {
        locationCache.filterLocations(searchTerm: "Ac")
        XCTAssertTrue(locationCache.filteredLocations.isEmpty)
    }
    
    func testSearchValidString() {
        locationCache.filterLocations(searchTerm: "Ab")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 2)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[3].id)
    }
    
    func testSearchValidStringWithSpace() {
        locationCache.filterLocations(searchTerm: "A b")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 1)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[4].id)
    }
    
    func testSearchValidStringWithDash() {
        locationCache.filterLocations(searchTerm: "A-b")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 1)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[5].id)
    }
}
