//
//  MainController.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet var btnSettings: UIButton!
    @IBOutlet var cardDeskCollection: UICollectionView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbScore: UILabel!
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippeedCardIndex: IndexPath?
    var count = 0
    var timer:Timer?
    
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        //cardDeskCollection.backgroundColor = UIColor.white
        //set layout
        let layout = UICollectionViewFlowLayout()
        //let wid = self.calculateWidth()
        layout.itemSize = calSizeofItem()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        cardDeskCollection.collectionViewLayout = layout
        //register
        cardDeskCollection.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        cardDeskCollection.delegate = self
        cardDeskCollection.dataSource = self
        //create timer
    }
    //call again each time view controller reload
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1. Set defaults value
        //get name
        var myName = Keys.defaults.string(forKey: Keys.name)
        if myName == nil {
            myName = "Johny"
            Keys.defaults.set(myName, forKey: Keys.name)
        }
        lbName.text = myName
        //get number of cards
        var myNumber = Keys.defaults.string(forKey: Keys.numOfCards)
        if myNumber == nil {
            myNumber = "8"
            Keys.defaults.set(myNumber, forKey: Keys.numOfCards)
        }
        //get my time
        var myTime = Keys.defaults.string(forKey: Keys.sec)
        if myTime == nil {
            myTime = "20"
            Keys.defaults.set(myTime, forKey: Keys.sec)
        }
        if let sec = Keys.defaults.string(forKey: Keys.sec){
            count = Int(sec)!
        }
        lbTime.text = myTime
        if let intValue = Int(myNumber!){
            cardArray = model.getCards(number: intValue / 2)
        }
        //let number = Int(myNumber) / 2
        
        //get card array
        //cardArray = model.getCards(number: number)
        //set timmer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.cardDeskCollection.reloadData()
    }
    
    //update timer
    @objc func updateTimer(){
        count -= 1
        lbTime.text = String(count)
        if(count < 1){
            timer?.invalidate()
            goToResultScreen()
        }
    }
    
    func goToResultScreen(){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        //if lose
        if !checkResult() {
            vc?.isWon = false
            if count > 0 {
                timer?.invalidate()
            }
        } else {
            if count > 0 {
                timer?.invalidate()
            }
            vc?.isWon = true
            let myScore = Score()
            //set level card
            myScore.numOfCards = cardArray.count
            //set my score
            if let sec = Keys.defaults.string(forKey: Keys.sec){
                myScore.time = Int(sec)! - count
                myScore.score = Int(sec)! - count
                vc?.score = myScore.time
            }
            //get current highest score
            let highest = Keys.defaults.integer(forKey: String(Keys.numOfCards))
            //if there is no highest
            if highest == 0{
                //my bigass bug
                Keys.defaults.set(myScore.score, forKey: String(Keys.defaults.integer(forKey: Keys.numOfCards)))
                myScore.isHighest = true
                vc?.isHighest = true
            } else {
                //if current score is
                if myScore.score! < highest {
                    //my f bigass bug
                    Keys.defaults.set(myScore.score,forKey: String(Keys.defaults.integer(forKey: Keys.numOfCards)))
                    myScore.isHighest = true
                    vc?.isHighest = true
                } else {
                    vc?.isHighest = false
                    myScore.isHighest = false
                }
            }
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickSettings(_ sender: Any) {
        timer?.invalidate()
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingController") as? SettingController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getSettingsInfo(){
        if let name = Keys.defaults.string(forKey: Keys.name){
            //set label name
            lbName.text = name
        }
        if let sec = Keys.defaults.string(forKey: Keys.sec){
            //set label time
            lbTime.text = "\(sec)"
        }
        
        
    }
    //check if cards are matched
    func checkforMatchCard(_ secondFlipCardIndex: IndexPath){
        let firstCardCell = cardDeskCollection.cellForItem(at: firstFlippeedCardIndex!) as? MyCollectionViewCell
        let secondCardCell = cardDeskCollection.cellForItem(at: secondFlipCardIndex) as? MyCollectionViewCell
        let cardOne = cardArray[firstFlippeedCardIndex!.row]
        let cardTwo = cardArray[secondFlipCardIndex.row]
        //compare 2 card
        if cardOne.imageName == cardTwo.imageName {
            
            //set status to match
            cardOne.isMatch = true
            cardTwo.isMatch = true
            
            //remove card
            firstCardCell?.remove()
            secondCardCell?.remove()
            //check end game
            if checkEndGame() {
                timer?.invalidate()
                goToResultScreen()
                
            }
            //2 card do not match
        } else {
            cardOne.isFlipped = false;
            cardTwo.isFlipped = false;
            //flip back
            firstCardCell?.flipBack()
            secondCardCell?.flipBack()
        }
        if firstCardCell == nil {
            cardDeskCollection.reloadItems(at: [firstFlippeedCardIndex!])
        }
        firstFlippeedCardIndex = nil
    }
    
    func checkEndGame() -> Bool{
        if checkOutOfCards(){
            return true
        } else if count < 1 {
            return true
        }
        return false
    }
    func checkOutOfCards() -> Bool{
        var check = true
        for card in cardArray {
            if !card.isMatch {
                check = false
                break;
            }
        }
        return check
    }
    func checkResult() -> Bool{
        if checkOutOfCards() {
            return true
        } else {
            return false
        }
        
    }
    
    func getHeightFor4() -> Int{
        let contentSize = cardDeskCollection.frame.width
        let allSpace = (cardArray.count / 4) - 1
        let eachImageSize = (Int(contentSize) - 20 * 5)/4
        var numRow = cardArray.count / 4
        if cardArray.count % 4 != 0 {
            numRow += 1
        }
        let heightContent = allSpace * 20 + Int(eachImageSize) * (numRow)
        return heightContent
    }
    
    func getHeightForNumberOfRow(numRow: Int, numItemRow: Int) -> Int {
        let contentSize = cardDeskCollection.frame.width
        let allSpace = numRow - 1
        let eachImageSize = (Int(contentSize) - 20 * (numItemRow + 1)) / numItemRow
        let heightContent = allSpace * 20 + Int(eachImageSize) * numRow
        return heightContent
    }
    
    
    func calSizeofItem() -> CGSize{
//        let width = cardDeskCollection.frame.size.width
//        if getHeightFor4() > Int(width) {
//
//            let numOfItemEachRow = cardArray.count / 4
//            return CGSize(width: (Int(width) - 100)/numOfItemEachRow,height: (Int(width) - 100)/numOfItemEachRow)
//        }
//        return CGSize(width: (width - 100)/4, height: (width - 100)/4)
        
        let width = cardDeskCollection.frame.size.width
        //let height = getHeightFor4()
        //let height = cardDeskCollection.contentSize.height
        let height = cardDeskCollection.frame.height
        if getHeightFor4() > Int(height) {
            var i = 4
            var numRow = cardArray.count / i
            //number of row when = 4
            //var j = calNumOfRow()
            while (getHeightForNumberOfRow(numRow: numRow , numItemRow: i) > Int(height)){
                i += 1
                if cardArray.count % i == 0 {
                    numRow = cardArray.count / i
                } else {
                    numRow = cardArray.count / i + 1
                }
            }
            let numOfItemEachRow = i
            return CGSize(width: (Int(width) - 20 * (numOfItemEachRow+1))/numOfItemEachRow,height: (Int(width) - 20 * (numOfItemEachRow + 1))/numOfItemEachRow)
        } else {
            return CGSize(width: (width - 100)/4, height: (width - 100)/4)
        }
        
    }
    
    func calNumOfRow() -> Int {
        /*
        let width = cardDeskCollection.frame.size.width
        if getHeightFor4() > Int(width) {
            return 4
        } else {
            return cardArray.count / 4 + 1
        }
 */
        let height = cardDeskCollection.frame.height
        //let height = cardDeskCollection.contentSize.height
        //let height = cardDeskCollection.contentSize.height
        let width = cardDeskCollection.frame.size.width
        if getHeightFor4() > Int(width) {
            var i = 4
            var numRow = cardArray.count / i
            //number of row when = 4
            //var j = calNumOfRow()
            while (getHeightForNumberOfRow(numRow: numRow , numItemRow: i) > Int(height)){
                i += 1
                if cardArray.count % i == 0 {
                    numRow = cardArray.count / i
                } else {
                    numRow = cardArray.count / i + 1
                }
            }
            return numRow
        } else {
            if cardArray.count % 4 == 0 {
                return cardArray.count / 4
            } else {
                return cardArray.count / 4 + 1
            }
            
        }
        
    }
    
    func calNumOfItemEachRow() -> Int {
        /*
        let width = cardDeskCollection.frame.size.width
        if getHeightFor4() > Int(width) {
            return cardArray.count / 4
        } else {
            return 4
        }
 */
        //let height = cardDeskCollection.contentSize.height
        let height = cardDeskCollection.frame.height
        let width = cardDeskCollection.frame.size.width
        if getHeightFor4() > Int(width) {
            var i = 4
            var numRow = cardArray.count / i
            //number of row when = 4
            //var j = calNumOfRow()
            while (getHeightForNumberOfRow(numRow: numRow , numItemRow: i) > Int(height)){
                i += 1
                if cardArray.count % i == 0 {
                    numRow = cardArray.count / i
                } else {
                    numRow = cardArray.count / i + 1
                }
            }
            return i
        } else {
            return 4
        }
        
    }
    
}

extension MainController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cardDeskCollection.cellForItem(at: indexPath) as! MyCollectionViewCell
        let card = cardArray[indexPath.row]
        //cell.flip()
        if !card.isFlipped && !card.isMatch {
            cell.flip()
            card.isFlipped = true
            if firstFlippeedCardIndex == nil {
                firstFlippeedCardIndex = indexPath
            } else {
                checkforMatchCard(indexPath)
            }
        } else {
            cell.flipBack()
            card.isFlipped = false
        }
    }
    
    
}



extension MainController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = Keys.defaults.integer(forKey: Keys.numOfCards)
//        if count == 0 {
//            Keys.defaults.set(8, forKey: Keys.numOfCards)
//            return 8
//        } else {
//            return count
//        }
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardDeskCollection.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    
}
extension MainController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.size.width
//        if getHeightFor4() > Int(width) {
//            let numOfItemEachRow = cardArray.count / 4
//            return CGSize(width: (Int(width) - 100)/numOfItemEachRow,height: (Int(width) - 100)/numOfItemEachRow)
//        }
//        return CGSize(width: (width - 100)/4, height: (width - 100)/4)
        return calSizeofItem()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //let contentSize = collectionView.frame.width
        //let allSpace = (cardArray.count / calNumOfRow()) - 1
        let allSpace = calNumOfRow() - 1
        let eachImageSize = calSizeofItem().width
        let heightContent = allSpace * 20 + Int(eachImageSize) * (calNumOfRow())
        
        var distant = (collectionView.frame.size.height - CGFloat(heightContent))/2
        if collectionView.frame.size.height < CGFloat(heightContent) {
            distant = 0
        }
        return UIEdgeInsets(top: distant, left: 20, bottom: 0, right: 20)
        
//        CGFloat height = myCollectionView.collectionViewLayout.collectionViewContentSize.height
//        heightConstraint.constant = height
//        self.view.setNeedsLayout() Or self.view.layoutIfNeeded()
       // return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        /*
         let contentSize = collectionView.frame.width
         let allSpace = (cardArray.count / 4) + 1
         let eachImageSize = (contentSize - 100)/4
         let heightContent = allSpace * 20 + Int(eachImageSize) * (cardArray.count / 4)
         let distant = (collectionView.frame.height - CGFloat(heightContent))/2
         return UIEdgeInsets(top: distant, left: 20, bottom: distant, right: 20)
         */
    }
    
}

