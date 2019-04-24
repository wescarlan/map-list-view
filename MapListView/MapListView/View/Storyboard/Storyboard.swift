//
//  Storyboard.swift
//  MapListView
//
//  Created by Wesley on 4/23/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation
import UIKit

class Storyboard {
    
    class var main: UIStoryboard { return UIStoryboard.init(name: "Main", bundle: nil) }
}

extension UIStoryboard {
    
    func viewController<T>(type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: "\(type)") as? T
    }
}
