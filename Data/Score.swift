//
//  Score.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/26/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation
class Score {
    var score: Int? = nil
    var numOfCards: Int? = nil
    var time:Int? = nil
    var isHighest = false
//    init(score: Int, numOfCards: Int, time: Int, isHighest: Bool) {
//        self.score = score
//        self.isHighest = isHighest
//        self.numOfCards = numOfCards
//        self.time = time
//    }
//    required convenience init(coder aDecoder: NSCoder){
//        let score = aDecoder.decodeCInt(forKey: "score")
//        let numOfCards = aDecoder.decodeCInt(forKey: "numOfCards")
//        let time = aDecoder.decodeCInt(forKey: "time")
//        let isHighest = aDecoder.decodeBool(forKey: "isHighest")
//        self.init(score: score, numOfCards: numOfCards, time: time, isHighest: isHighest)
//
//    }
}

/*
 class Team: NSObject, NSCoding {
     var id: Int
     var name: String
     var shortname: String


     init(id: Int, name: String, shortname: String) {
         self.id = id
         self.name = name
         self.shortname = shortname

     }

     required convenience init(coder aDecoder: NSCoder) {
         let id = aDecoder.decodeInteger(forKey: "id")
         let name = aDecoder.decodeObject(forKey: "name") as! String
         let shortname = aDecoder.decodeObject(forKey: "shortname") as! String
         self.init(id: id, name: name, shortname: shortname)
     }

     func encode(with aCoder: NSCoder) {
         aCoder.encode(id, forKey: "id")
         aCoder.encode(name, forKey: "name")
         aCoder.encode(shortname, forKey: "shortname")
     }
 }
 */
