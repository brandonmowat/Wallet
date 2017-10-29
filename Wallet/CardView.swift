//
//  CardViewController.swift
//  Wallet
//
//  Created by Brandon Mowat on 2017-06-04.
//  Copyright © 2017 Brandon Mowat. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var gradient: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        gradient = CAGradientLayer()
        gradient?.frame = bounds
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 1)
        gradient?.colors = [UIColor(red: 101/255, green: 52/255, blue: 1.0, alpha: 1.0).cgColor,
                            UIColor(red:222/255, green:138/255, blue:1.0, alpha: 1.0).cgColor]
        layer.insertSublayer(gradient!, at: 0)
        
        setupGestures()
    }
    
    public var walletView: WalletView? {
        return container()
    }
    
    let tapGesture = UITapGestureRecognizer()
    let panGesture = UIPanGestureRecognizer()
    
    @objc
    func tapped() {
        print("Card tapped")
        walletView?.makePresentationLayout(card: self)
    }
    
    @objc
    func panned(gestureRecognizer: UIPanGestureRecognizer) {
        print("Panned")
        switch gestureRecognizer.state {
        case .began:
            updateGrabbedCardViewOffset(gestureRecognizer: gestureRecognizer)
        case .changed:
            updateGrabbedCardViewOffset(gestureRecognizer: gestureRecognizer)
        case .ended:
            panGestureEnded(gestureRecognizer: gestureRecognizer)
        default:
            updateGrabbedCardViewOffset(gestureRecognizer: gestureRecognizer)
        }
    }
    
    func panGestureEnded(gestureRecognizer: UIPanGestureRecognizer) {
        let offset = gestureRecognizer.translation(in: walletView).y
        if (abs(offset) > 100) {
            let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.walletView?.updateGrabbedCardView(offset: 1000, card: self)
            })
            animation.addCompletion({ _ in
                self.walletView?.animateToStackLayout()
            })
            animation.startAnimation()
        } else {
            let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.walletView?.updateGrabbedCardView(offset: 0, card: self)
            })
            animation.startAnimation()
        }
    }
    
    func updateGrabbedCardViewOffset(gestureRecognizer: UIPanGestureRecognizer) {
        let offset = gestureRecognizer.translation(in: walletView).y
        print(offset)
        walletView?.updateGrabbedCardView(offset: offset, card: self)
    }
        
    func setupGestures() {
        tapGesture.addTarget(self, action: #selector(tapped))
        panGesture.addTarget(self, action: #selector(panned))
        addGestureRecognizer(tapGesture)
    }
    
    func addPanGesture() {
        addGestureRecognizer(panGesture)
    }
    
    func removePanGesture() {
        removeGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

internal extension UIView {
    
    func container<T: UIView>() -> T? {
        
        var view = superview
        
        while view != nil {
            if let view = view as? T {
                return view
            }
            view = view?.superview
        }
        
        return nil
    }
    
}

