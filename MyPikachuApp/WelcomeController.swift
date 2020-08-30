//
//  WelcomeController.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {

    @IBOutlet var btnPlay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickPlay(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController") as? MainController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
