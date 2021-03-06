//
//  MapViewController.swift
//  MapListView
//
//  Created by Wesley on 4/19/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    @IBOutlet fileprivate var searchContainerView: SlidingOverlayView!
    @IBOutlet private var tabView: UIView!
    @IBOutlet private var searchListView: SearchListView!
    
    private var hasSetSearchContainerPostitions = false
    private var locationCache: LocationCacheInterface { return LocationCache.sharedInstance }
    fileprivate var locations: [LocationDataModel] { return locationCache.filteredLocations }
    
    private lazy var searchContainerBottomPosition: CGFloat = {
        var minHeight = searchListView.searchBarHeight
        if #available(iOS 11.0, *) {
            minHeight += view.safeAreaInsets.bottom
        }
        return minHeight
    }()
    
    private lazy var searchContainerMiddlePosition: CGFloat = {
        return 0.35 * UIScreen.main.bounds.height
    }()
    
    private lazy var searchContainerTopPosition: CGFloat = {
        var maxY = view.bounds.maxY
        if #available(iOS 11.0, *) {
            maxY -= view.safeAreaInsets.top
        }
        return maxY
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchView()
    }
    
    private func setUpSearchView() {
        // Set search view corner radius and drop shadow
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.layer.masksToBounds = false
        searchContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        searchContainerView.layer.shadowOffset = CGSize(width: 1, height: 3)
        searchContainerView.layer.shadowOpacity = 0.7
        searchContainerView.layer.shadowRadius = 5
        
        // Set tab view corner radius
        tabView.layer.cornerRadius = 2.5
        
        // Set delegates
        searchListView.delegate = self
        searchListView.tableView.delegate = self
        searchListView.tableView.dataSource = self
        searchContainerView.delegate = self
        
        // Register cells
        searchListView.tableView.register(
            UINib(nibName: "\(LocationTableViewCell.self)", bundle: nil),
            forCellReuseIdentifier: "\(LocationTableViewCell.self)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set sliding positions of search view
        if !hasSetSearchContainerPostitions {
            searchContainerView.bottomPosition = searchContainerBottomPosition
            searchContainerView.middlePosition = searchContainerMiddlePosition
            searchContainerView.topPosition = searchContainerTopPosition
            hasSetSearchContainerPostitions = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        hasSetSearchContainerPostitions = false
    }
    
    fileprivate func scrollToLocation(_ location: LocationDataModel) {
        // Remove previous map annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Convert the location coordinate to CLLocationCoordinate2D
        let locationCoordinate = location.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        // Set the map span and region
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Add a map annotation at the coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        searchContainerView.setPosition(.bottom)
    }
}

// MARK: - UITableViewDelegate -
extension MapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let location = locations[indexPath.row]
        searchListView.searchBar.text = location.city
        scrollToLocation(location)
    }
}

// MARK: - UITableViewDataSource -
extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(LocationTableViewCell.self)", for: indexPath)
        guard let locationCell = cell as? LocationTableViewCell else { return cell }
        locationCell.location = locations[indexPath.row]
        return locationCell
    }
}

// MARK: - SlidingOverlayViewDelegate -
extension MapViewController: SlidingOverlayViewDelegate {
    func didSetPostion(_ position: CGFloat) {
        searchListView.tableView.isHidden = position <= searchContainerBottomPosition + 20
    }
}

// MARK: - SearchListViewDelegate -
extension MapViewController: SearchListViewDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchContainerView.setPosition(.top)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard !searchContainerView.isPanning else { return true }
        searchContainerView.setPosition(.middle)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locationCache.filterLocations(searchTerm: searchText)
        searchListView.tableView.reloadData()
    }
}
