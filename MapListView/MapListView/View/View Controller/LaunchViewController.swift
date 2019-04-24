//
//  LaunchViewController.swift
//  MapListView
//
//  Created by Wesley on 4/23/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet private var loadingContainerView: UIView!
    
    private lazy var locationCoordinator: LocationCoordinator = {
        let coordinator = LocationCoordinator()
        coordinator.delegate = self
        return coordinator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingContainerView.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        loadingContainerView.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationCoordinator.getLocations()
    }
    
    fileprivate func navigateToMap() {
        guard let mapVC = Storyboard.main.viewController(type: MapViewController.self) else { return }
        let navigationController = UINavigationController(rootViewController: mapVC)
        navigationController.isNavigationBarHidden = true
        AppDelegate.navigationController = navigationController
    }
    
    fileprivate func showError(_ error: Error?) {
        let alertController = UIAlertController.init(
            title: "Unable to load locations",
            message: error?.localizedDescription,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}

// MARK: - LocationCoordinatorDelegate -
extension LaunchViewController: LocationCoordinatorDelegate {
    func didGetLocations(_ locations: [LocationDataModel]) {
        navigateToMap()
    }
    
    func didFailGettingLocations(error: Error?) {
        showError(error)
    }
}
