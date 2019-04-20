//
//  SearchListView.swift
//  MapListView
//
//  Created by Wesley on 4/20/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

class SearchListView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        Bundle.main.loadNibNamed("\(SearchListView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        
        setUpSearchBar()
    }
    
    private func setUpSearchBar() {
        searchBar?.delegate = self
    }
}

extension SearchListView: UISearchBarDelegate {
    
}
