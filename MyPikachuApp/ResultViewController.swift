//
//  ResultViewController.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/26/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var lbHighScore: UILabel!
    @IBOutlet var imgDiamond: UIImageView!
    @IBOutlet var btnPlayAgain: UIButton!
    @IBOutlet var lbScore: UILabel!
    
    @IBOutlet var imgSad: UIImageView!
    @IBOutlet var lbResult: UILabel!
    var isWon = false
    var score: Int? = nil
    var isHighest: Bool? = nil
    var result: String? = nil
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isWon {
            lbResult.text = "You Lost"
            lbScore.isHidden = true
            lbHighScore.isHidden = true
            imgDiamond.isHidden = true
            imgSad.isHidden = false
        } else {
            lbResult.text = "You Won"
            lbScore.isHidden = false
            lbScore.text = "\(score!) secs"
            imgSad.isHidden = true
            displayHighScore()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickPlayAgain(_ sender: Any) {
        //print(Keys.defaults.integer(forKey: Keys.numOfCards))
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as? MainController
        self.navigationController?.pushViewController(vc!, animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
    
    func displayHighScore(){
        if isHighest! {
            lbHighScore.isHidden = false
            imgDiamond.isHidden = false
        } else {
            lbHighScore.isHidden = true
            imgDiamond.isHidden = true
        }
    }
    
    
}
