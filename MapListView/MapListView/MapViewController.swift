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
    
    private var searchContainerLastY: CGFloat = 0
    fileprivate var isPanningSearchContainer = false
    
    fileprivate lazy var searchContainerMinY: CGFloat = {
        var minHeight = searchListView.searchBarHeight
        if #available(iOS 11.0, *) {
            minHeight += view.safeAreaInsets.bottom
        }
        return minHeight
    }()
    
    fileprivate lazy var searchContainerMiddleY: CGFloat = {
        return 0.35 * UIScreen.main.bounds.height
    }()
    
    fileprivate lazy var searchContainerMaxY: CGFloat = {
        var maxY = view.bounds.maxY
        if #available(iOS 11.0, *) {
            maxY -= view.safeAreaInsets.top
        }
        return maxY
    }()
    
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
        
        // Set initial position of search view
        searchContainerViewHeightConstraint.constant = searchContainerMiddleY
        
        // Set tab view corner radius
        tabView.layer.cornerRadius = 2.5
        
        searchListView.delegate = self
    }
    
    @IBAction func panView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        switch gestureRecognizer.state {
        case .began:
            isPanningSearchContainer = true
            searchContainerLastY = searchContainerView.bounds.maxY
            view.endEditing(true)
        case .changed:
            let translation = gestureRecognizer.translation(in: view.superview)
            let yTranslation = translation.y
            var newY = searchContainerLastY - yTranslation
            if yTranslation > 0 {
                newY = max(newY, searchContainerMinY)
            } else {
                newY = min(newY, searchContainerMaxY)
            }
            searchContainerViewHeightConstraint.constant = newY
        case .cancelled, .ended, .failed:
            isPanningSearchContainer = false
            animateToNearestSearchContainerPosition()
        default:
            break
        }
    }
    
    private func animateToNearestSearchContainerPosition() {
        let currentPosition = searchContainerViewHeightConstraint.constant
        let maxPositionOffset = abs(searchContainerMaxY - currentPosition)
        let middlePostitionOffset = abs(searchContainerMiddleY - currentPosition)
        let minPostitionOffset = abs(searchContainerMinY - currentPosition)
        
        var newY: CGFloat
        if maxPositionOffset > 100 && middlePostitionOffset < minPostitionOffset {
            newY = searchContainerMiddleY
        } else if middlePostitionOffset < minPostitionOffset {
            newY = searchContainerMiddleY
        } else {
            newY = searchContainerMinY
        }
        animateSearchContainerToPosition(newY, duration: 0.25)
    }
    
    fileprivate func animateSearchContainerToPosition(_ position: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.searchContainerViewHeightConstraint.constant = position
            strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - MKMapViewDelegate -
extension MapViewController: MKMapViewDelegate {
    
}

// MARK: - SearchListViewDelegate -
extension MapViewController: SearchListViewDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        animateSearchContainerToPosition(searchContainerMaxY, duration: 0.25)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard !isPanningSearchContainer else { return true }
        animateSearchContainerToPosition(searchContainerMiddleY, duration: 0.3)
        return true
    }
}
