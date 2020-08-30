//
//  CardModel.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/26/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

class CardModel {
    func getCards(number: Int) -> [Card]{
        var generateCard = [Card]()
        for _ in 1...number {
            let randomNum = Int.random(in: 1...8)
            let myCard = Card()
            myCard.imageName = "img\(randomNum)"
            generateCard.append(myCard)
            let myCard2 = Card()
            myCard2.imageName = "img\(randomNum)"
            generateCard.append(myCard2)
        }
        generateCard.shuffle()
        return generateCard
    }
}
