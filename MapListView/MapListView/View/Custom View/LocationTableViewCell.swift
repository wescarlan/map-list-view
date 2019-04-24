//
//  LocationTableViewCell.swift
//  MapListView
//
//  Created by Wesley on 4/23/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    var location: LocationDataModel? {
        didSet {
            setTitleLabel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleLabel()
    }
    
    private func setTitleLabel() {
        guard let location = location else {
            titleLabel?.text = ""
            return
        }
        titleLabel?.text = "\(location.city), \(location.country)"
    }
}
