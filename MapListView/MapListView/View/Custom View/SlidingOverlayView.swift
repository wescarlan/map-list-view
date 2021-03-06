//
//  SlidingOverlayView.swift
//  MapListView
//
//  Created by Wesley on 4/21/19.
//  Copyright © 2019 Wesley. All rights reserved.
//

import Foundation
import UIKit

enum SlidingOverlayState {
    case bottom, middle, top
}

protocol SlidingOverlayViewDelegate: class {
    func didSetPostion(_ position: CGFloat)
}

class SlidingOverlayView: UIView {
    
    static let animationDuration: TimeInterval = 0.3
    
    weak var delegate: SlidingOverlayViewDelegate?
    
    var bottomPosition: CGFloat = 0
    var middlePosition: CGFloat = UIScreen.main.bounds.height / 2
    var topPosition: CGFloat = UIScreen.main.bounds.height
    var isPanning = false
    
    private var currentPosition: SlidingOverlayState = .middle
    private var heightConstraint: NSLayoutConstraint!
    private var searchContainerLastY: CGFloat = 0
    private var searchContainerNewY: CGFloat = 0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setUpHeightConstraint()
        setUpGestureRecognizer()
    }
    
    private func setUpHeightConstraint() {
        // Look for an existing height constraint, otherwise create one
        guard let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) else {
            let heightConstraint = NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: middlePosition)
            NSLayoutConstraint.activate([heightConstraint])
            self.heightConstraint = heightConstraint
            return
        }
        self.heightConstraint = heightConstraint
    }
    
    private func setUpGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - Position setters
    func setPosition(_ state: SlidingOverlayState) {
        switch state {
        case .bottom: setPosition(bottomPosition)
        case .middle: setPosition(middlePosition)
        case .top: setPosition(topPosition)
        }
        currentPosition = state
    }
    
    private func setPosition(_ position: CGFloat) {
        UIView.animate(withDuration: SlidingOverlayView.animationDuration, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.heightConstraint.constant = position
            self?.superview?.layoutIfNeeded()
        }, completion: nil)
        delegate?.didSetPostion(position)
    }
    
    private func setToNextPosition() {
        // If the user has not panned past a certain threshold, don't change the current position
        let positionOffset = searchContainerNewY - searchContainerLastY
        guard abs(positionOffset) > 20 else {
            setPosition(currentPosition)
            return
        }
        
        // Set to next relevant position
        if (positionOffset > 0) {
            switch currentPosition {
            case .bottom: setPosition(.middle)
            default: setPosition(.top)
            }
        } else {
            switch currentPosition {
            case .top: setPosition(.middle)
            default: setPosition(.bottom)
            }
        }
    }
    
    // MARK: - Pan gesture
    @objc
    private func panView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        switch gestureRecognizer.state {
        case .began:
            isPanning = true
            searchContainerLastY = bounds.maxY
            view.endEditing(true)
        case .changed:
            let translation = gestureRecognizer.translation(in: view.superview)
            let yTranslation = translation.y
            var newY = searchContainerLastY - yTranslation
            if yTranslation > 0 {
                // Don't pan past the bottom position
                newY = max(newY, bottomPosition)
            } else {
                // Don't pan past the top position
                newY = min(newY, topPosition)
            }
            heightConstraint.constant = newY
            searchContainerNewY = newY
            delegate?.didSetPostion(newY)
        case .cancelled, .ended, .failed:
            isPanning = false
            setToNextPosition()
        default:
            break
        }
    }
}
