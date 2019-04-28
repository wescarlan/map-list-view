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
    
    lazy var sortedMockLocations: [LocationDataModel] = [
        mockLocations[8], // ""
        mockLocations[0], // "A"
        mockLocations[1], // "a"
        mockLocations[4], // "A b"
        mockLocations[5], // "A-b"
        mockLocations[2], // "Ab"
        mockLocations[3], // "Abc"
        mockLocations[6], // "B"
        mockLocations[7]  // "C"
    ]
    
    override func setUp() {
        super.setUp()
        locationCache = LocationCache()
        locationCache.setLocations(mockLocations)
    }
    
    func testSetLocations() {
        XCTAssertEqual(locationCache.allLocations.count, sortedMockLocations.count)
        XCTAssertEqual(locationCache.allLocations[0].id, sortedMockLocations[0].id)
        XCTAssertEqual(locationCache.allLocations[1].id, sortedMockLocations[1].id)
        XCTAssertEqual(locationCache.allLocations[2].id, sortedMockLocations[2].id)
        XCTAssertEqual(locationCache.allLocations[3].id, sortedMockLocations[3].id)
        XCTAssertEqual(locationCache.allLocations[4].id, sortedMockLocations[4].id)
        XCTAssertEqual(locationCache.allLocations[5].id, sortedMockLocations[5].id)
        XCTAssertEqual(locationCache.allLocations[6].id, sortedMockLocations[6].id)
        XCTAssertEqual(locationCache.allLocations[7].id, sortedMockLocations[7].id)
        XCTAssertEqual(locationCache.allLocations[8].id, sortedMockLocations[8].id)
        
        XCTAssertEqual(locationCache.filteredLocations.count, sortedMockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations[0].id, sortedMockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, sortedMockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, sortedMockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, sortedMockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, sortedMockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, sortedMockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[6].id, sortedMockLocations[6].id)
        XCTAssertEqual(locationCache.filteredLocations[7].id, sortedMockLocations[7].id)
        XCTAssertEqual(locationCache.filteredLocations[8].id, sortedMockLocations[8].id)
    }
    
    func testSearchEmptyString() {
        locationCache.filterLocations(searchTerm: "")
        
        XCTAssertEqual(locationCache.filteredLocations.count, sortedMockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations.count, sortedMockLocations.count)
        XCTAssertEqual(locationCache.filteredLocations[0].id, sortedMockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, sortedMockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, sortedMockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, sortedMockLocations[3].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, sortedMockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, sortedMockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[6].id, sortedMockLocations[6].id)
        XCTAssertEqual(locationCache.filteredLocations[7].id, sortedMockLocations[7].id)
        XCTAssertEqual(locationCache.filteredLocations[8].id, sortedMockLocations[8].id)
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
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[3].id)
    }
    
    func testSearchValidLowercaseCharacter() {
        locationCache.filterLocations(searchTerm: "a")
        
        XCTAssertEqual(locationCache.filteredLocations.count, 6)
        XCTAssertEqual(locationCache.filteredLocations[0].id, mockLocations[0].id)
        XCTAssertEqual(locationCache.filteredLocations[1].id, mockLocations[1].id)
        XCTAssertEqual(locationCache.filteredLocations[2].id, mockLocations[4].id)
        XCTAssertEqual(locationCache.filteredLocations[3].id, mockLocations[5].id)
        XCTAssertEqual(locationCache.filteredLocations[4].id, mockLocations[2].id)
        XCTAssertEqual(locationCache.filteredLocations[5].id, mockLocations[3].id)
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
