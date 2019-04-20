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
    @IBOutlet private var searchContainerView: UIView!
    @IBOutlet private var searchContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var tabView: UIView!
    @IBOutlet private var searchListView: SearchListView!
    
    private var lastSearchContainerY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        setUpSearchView()
    }
    
    private func setUpMapView() {
        mapView.delegate = self
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
    }
    
    @IBAction func panView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        switch gestureRecognizer.state {
        case .began:
            lastSearchContainerY = searchContainerView.bounds.maxY
        case .changed:
            let translation = gestureRecognizer.translation(in: view.superview)
            let newY = lastSearchContainerY - translation.y
            searchContainerViewHeightConstraint.constant = newY
        default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate -
extension MapViewController: MKMapViewDelegate {
    
}
