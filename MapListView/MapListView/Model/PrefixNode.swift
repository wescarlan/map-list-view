//
//  PrefixNode.swift
//  MapListView
//
//  Created by Wesley on 4/21/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation

class PrefixNode {
    
    // MARK: - Next letters
    var childNodes = [String: PrefixNode]()
    
    // MARK - Index range
    var firstIndex: Int
    var lastIndex: Int
    
    var indexRange: Range<Int> {
        return Range(firstIndex...lastIndex)
    }
    
    // MARK: - Head node initializer
    init(size: Int) {
        firstIndex = 0
        lastIndex = size - 1
    }
    
    // MARK: - Insertion
    init(index: Int, prefix: String) {
        firstIndex = index
        lastIndex = index
        let prefix = prefix.lowercased()
        update(index: index, prefix: prefix)
    }
    
    func update(index: Int, prefix: String) {
        lastIndex = index
        let prefix = prefix.lowercased()
        let nextLetter = String(prefix.prefix(1))
        guard !nextLetter.isEmpty else { return }
        
        let childPrefix = nextPrefix(prefix)
        if let childNode = childNodes[nextLetter] {
            childNode.update(index: index, prefix: childPrefix)
        } else {
            childNodes[nextLetter] = PrefixNode(index: index, prefix: childPrefix)
        }
    }
    
    // MARK: - Search
    func find(prefix: String) -> Range<Int>? {
        let prefix = prefix.lowercased()
        let nextLetter = String(prefix.prefix(1))
        guard !nextLetter.isEmpty else { return indexRange }
        guard let childNode = childNodes[nextLetter] else { return nil }
        
        let childPrefix = nextPrefix(prefix)
        return childNode.find(prefix: childPrefix)
    }
    
    private func nextPrefix(_ prefix: String) -> String {
        let prefix = prefix.lowercased()
        return String(prefix.suffix(from: prefix.index(after: prefix.startIndex)))
    }
}
