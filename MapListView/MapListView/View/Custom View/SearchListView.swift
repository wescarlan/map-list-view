//
//  SearchListView.swift
//  MapListView
//
//  Created by Wesley on 4/20/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import UIKit

protocol SearchListViewDelegate: class {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
}

class SearchListView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: SearchListViewDelegate?
    
    var searchBarHeight: CGFloat {
        return searchBar?.frame.size.height ?? 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // Set custom nib
        Bundle.main.loadNibNamed("\(SearchListView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        
        backgroundColor = .clear
        
        setUpSearchBar()
    }
    
    private func setUpSearchBar() {
        searchBar?.delegate = self
        searchBar?.showsCancelButton = false
    }
}

// MARK - UISearchBarDelegate -
extension SearchListView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return delegate?.searchBarShouldBeginEditing(searchBar) ?? true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return delegate?.searchBarShouldEndEditing(searchBar) ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
