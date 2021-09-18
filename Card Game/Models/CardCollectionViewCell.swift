//
//  CardCollectionViewCell.swift
//  Card Game
//
//  Created by kadir yapar on 15.9.2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card:Card) {
        
        //keep track of the card that gets passed in
        self.card = card
        
        if card.isMatched == true{
            
            //if the card has been matched, then make the imageview invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else{
            //if the card has not been matched, then make the imageview visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        backImageView.image = UIImage(named: card.imageName)
        
        //determine if the card is in a flipped up state or down state
        if card.isFlipped == true {
            
            // make sure the front imageview is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            
            //make sure the back imageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
    func remove() {
        
        //removes both imageviews from being visible
        backImageView.alpha = 0
        
        //animate the card removing
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)

    }
}
