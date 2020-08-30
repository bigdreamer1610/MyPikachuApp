//
//  MyCollectionViewCell.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgFront: UIImageView!
    
    @IBOutlet var imgBack: UIImageView!
    var card: Card?
    
    static let identifier = "MyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCard(_ card: Card){
        self.card = card
        //if card is matched, then make the imageview invisible
        if card.isMatch {
            imgBack.alpha = 0
            imgFront.alpha = 0
            return
        } else {
            imgBack.alpha = 1
            imgFront.alpha = 1
        }
        imgFront.image = UIImage(named: card.imageName)
        if card.isFlipped {
            UIView.transition(from: imgBack, to: imgFront, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: imgFront, to: imgBack, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        UIView.transition(from: imgBack, to: imgFront, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            UIView.transition(from: self.imgFront, to: self.imgBack, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove(){
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .transitionFlipFromLeft, animations: {
            self.imgFront.alpha = 0
            self.imgBack.alpha = 0
        }, completion: nil)
        
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    
}
