//
//  SettingController.swift
//  MyPikachuApp
//
//  Created by THUY Nguyen Duong Thu on 8/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

    @IBOutlet var txtSecond: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var txtNoOfCards: UITextField!
    //let defaults = UserDefaults.standard
    let numCards = [4,8,12,16,20,24,28,32,40,50,60,90]
    var selectedNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        //txtSecond.delegate = self
        displayDefaultSetiings()
        createNumberPicker()
        createToolBar()
    }
    //set up default settings
    func setUpUserDefaults(name: String?, sec: String?, number: String?){
        
        Keys.defaults.set(name, forKey: Keys.name)
        Keys.defaults.set(sec, forKey: Keys.sec)
        Keys.defaults.set(number, forKey: Keys.numOfCards)
        Keys.defaults.synchronize()
    }
    //display default settings
    func displayDefaultSetiings(){
        let myName2 = Keys.defaults.string(forKey: Keys.name)
        txtName.text = myName2
        let limitSecond2 = Keys.defaults.string(forKey: Keys.sec)
        txtSecond.text = limitSecond2
        let numOfCards = Keys.defaults.string(forKey: Keys.numOfCards)
        txtNoOfCards.text = numOfCards
    }
    
    //click Cancel
    @IBAction func clickCancel(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController") as? WelcomeController
        self.navigationController?.pushViewController(vc!, animated: true)
        //pop to the previous controller
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickSaveSettings(_ sender: Any) {
        setUpUserDefaults(name: txtName.text!,sec: txtSecond.text!, number: txtNoOfCards.text!)
        //show alert
//        let alert = UIAlertController(title: "Update Successfully", message: "You're welcome", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func createNumberPicker(){
        let numberPicker = UIPickerView()
        numberPicker.delegate = self
        txtNoOfCards.inputView = numberPicker
    }
    
    func createToolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        txtNoOfCards.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension SettingController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numCards.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numCards[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNumber = String(numCards[row])
        txtNoOfCards.text = selectedNumber
    }
}

//allow only text num
//extension SettingController : UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //only text num
//        let allowCharacters = "0123456789"
//        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
//        let typeCharacterSet = CharacterSet(charactersIn: string)
//        return allowCharacterSet.isSuperset(of: typeCharacterSet)
//        //return false
//    }
//}
