//
//  ViewController.swift
//  Wallet
//
//  Created by Brandon Mowat on 2017-06-04.
//  Copyright © 2017 Brandon Mowat. All rights reserved.
//

import UIKit

class WalletView: UIView, UIScrollViewDelegate {
    
    // Some constants
    var cardWidth: CGFloat?
    var cardHeight: CGFloat?
    let cardWidthDiff: CGFloat = CGFloat(30)
    let contentInsetTop: CGFloat = CGFloat(60)
    let animationDuration: Double = 1.0
    let cardSpacing: CGFloat = CGFloat(100)
    
    let scrollView = UIScrollView()
    
    var cards:[CardView] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        cardWidth = frame.size.width - cardWidthDiff
        cardHeight = cardWidth! / 1.6
        prepareWalletView()
        scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // initializes the entire wallet view
    func prepareWalletView() {
        prepareScrollView()
        prepareCards()
        makeStackLayout()
    }
    
    // initializes the scrollview that contains all of our cards in our wallet
    func prepareScrollView() {
        
        addSubview(scrollView)
        
        scrollView.clipsToBounds = false
        
        scrollView.isExclusiveTouch = true
        scrollView.alwaysBounceVertical = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleHeight, .flexibleWidth]
        scrollView.frame = bounds
        
        // 100 pt space up top
        scrollView.contentInset = UIEdgeInsets(top: self.contentInsetTop, left: 0, bottom: 0, right: 0)
        
    }
    
    func makePresentationLayout(card: CardView) {
        var offset: CGFloat = 0
        self.scrollView.isScrollEnabled = false
        card.addPanGesture()
        for cardViewIndex in 0..<self.cards.count {
            
            let cardView = self.cards[cardViewIndex]
            
            if (cardView == card) {
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.frame.origin.y = 100 + self.scrollView.contentOffset.y
                })
            } else {
                offset += 20
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.frame.origin.y = self.frame.height + self.scrollView.contentOffset.y - 50 + offset
                })
            }
            
        }
    }
    
    func animateToStackLayout() {
        scrollView.isScrollEnabled = true
        
        var cardViewYPoint = CGFloat(0)

        for cardViewIndex in 0..<self.cards.count {
            cards[cardViewIndex].removePanGesture()
            
            let cardView = self.cards[cardViewIndex]
            
            var cardViewFrame = CGRect(x: self.cardWidthDiff/2, y: cardViewYPoint, width: self.cardWidth!, height: self.cardHeight!)
            
            UIView.animate(withDuration: 0.3, animations: {
                cardView.frame = cardViewFrame
            })
            
            cardViewYPoint += self.cardSpacing
            
        }
    }
    
    func makeStackLayout() {
        
        scrollView.isScrollEnabled = true
        
        let zeroRectConvertedFromWalletView: CGRect = {
            var rect = convert(CGRect.zero, to: scrollView)
            rect.origin.y += scrollView.contentInset.top
            return rect
        }()
        
        let stretchingDistanse: CGFloat? = {
            
            let negativeScrollViewContentInsetTop = -(scrollView.contentInset.top)
            let scrollViewContentOffsetY = scrollView.contentOffset.y + 20
            
            print(negativeScrollViewContentInsetTop, scrollViewContentOffsetY)
            
            if negativeScrollViewContentInsetTop > scrollViewContentOffsetY {
                return fabs(fabs(negativeScrollViewContentInsetTop) + scrollViewContentOffsetY) / 6
            }
            
            return nil
        }()
        
        // let walletHeaderY = walletHeader?.frame.origin.y ?? zeroRectConvertedFromWalletView.origin.y
        
        var cardViewYPoint = CGFloat(0)
        
        let cardViewHeight = self.cardHeight!
        
        let firstCardView = self.cards.first
        
        for cardViewIndex in 0..<self.cards.count {
            
            let cardView = self.cards[cardViewIndex]
            
            var cardViewFrame = CGRect(x: self.cardWidthDiff/2, y: cardViewYPoint, width: self.cardWidth!, height: cardViewHeight)
            
            if cardView == firstCardView {
                if let stretchingDistanse = stretchingDistanse {
                    cardViewFrame.origin.y = cardViewFrame.origin.y - stretchingDistanse
                }
                cardView.frame = cardViewFrame
            } else {
                if let stretchingDistanse = stretchingDistanse {
                    cardViewFrame.origin.y += stretchingDistanse * CGFloat((cardViewIndex - 1))
                }
                cardView.frame = cardViewFrame
            }
            
            cardViewYPoint += self.cardSpacing
            
        }
        
    }
    
    
    func updateGrabbedCardView(offset: CGFloat, card: CardView) {
        card.frame.origin.y = offset + 60
        
    }
    
    func checkCardPositions() {
        makeStackLayout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkCardPositions()
    }
    
    // a method to prepare all of the cards in our wallet
    func prepareCards() {
        var spacing = self.cardSpacing
        for _ in 0...10 {
            self.cards.append(CardView(frame:
                CGRect(x: self.cardWidthDiff/2, y: spacing, width: cardWidth!, height: cardHeight!)))
            
            spacing += spacing
        }
        
        for i in self.cards {
            scrollView.addSubview(i)
        }
        scrollView.contentSize = CGSize(width: frame.width, height: cardHeight!+CGFloat(cardSpacing*10))
    }
    
    func addCard(card: CardView) {
        
    }
    

}

