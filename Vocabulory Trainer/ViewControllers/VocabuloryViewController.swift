//
//  ViewController.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 04/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import RealmSwift
import UIKit
import Foundation
import SwiftMessages
import ProgressHUD

class VocabuloryViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var LessonTitleLabel: UILabel!
    @IBOutlet weak var germanTxtLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var englishTranslationTextField: UITextField!

    let listItems = List<VocabuloryItem>()
    let csvString = Constants.tempCSVData
    var parsedCSV = Array<Dictionary<String, Any>>()
    var index = 0, totalCount = 0, completedCycle = 0, correctCounter = 0, wrongCounter = 0
    var updatedArray = List<VocabuloryItem>()
    var listView = [String]()
    var FinalArray = [[String]]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        CSVHandler.sharedInstance.creatCSV(filename: Constants.filename)
        CSVHandler.sharedInstance.readCsv(filename: Constants.filename)
        // TODO: Download csv file using download Manager
        DownloadManager.shared.downloadFile(url: "https://exmapleurl")
        
        if !UserDefaults.standard.bool(forKey: "Inserted") {
            CSVHandler.sharedInstance.csv(data: Constants.tempCSVData)
        }
        totalCount = RealmManager.sharedInstance.getDataFromRealm().count
        self.setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup UI View
    func setupView() {
        self.LessonTitleLabel.text = ""
        self.englishTranslationTextField.text = ""
        submitButton.setTitle("submit",for: .normal)
        
        if index < totalCount  {
            let updatedArray = RealmManager.sharedInstance.getItemFromRealmById(id: index)
            self.germanTxtLabel.text = updatedArray.germanText
            self.scoreLabel.text = String(format: "Score: %@", String(updatedArray.count))
        } else {
            submitButton.setTitle("Restart",for: .normal)
            self.germanTxtLabel.text = ""
            self.scoreLabel.text = String(format: "Score: %@", "Zero")
            restart()
        }
    }
    
    // MARK: - BusinessLogic Methods
    func restart() {
        let messsage = String(format: "You successfully finished your lesson \n CorrectAnswers: %d \r WrongAnswers: %d ", correctCounter, wrongCounter)
        showAlertWithMessage(message: messsage, title: "RESTART")
        index = 0
        completedCycle = completedCycle + 1
        correctCounter = 0
        wrongCounter = 0
    }
    
    func successfullyCompleted() {
        let messsage = "Congratulations!!! You just finished the lesson successfully"
        showAlertWithMessage(message: messsage, title: "FINISH")
        index = 0
        correctCounter = 0
        wrongCounter = 0
    }
    
    @IBAction func submit(_ sender: Any) {
        if index < totalCount {
            let updatedArray = RealmManager.sharedInstance.getItemFromRealmById(id: index)
            if self.englishTranslationTextField.text == updatedArray.englishText {
                ProgressHUD.showSuccess()
                self.showToast(message: "CORRECT")
                correctCounter = correctCounter + 1
                let item = VocabuloryItem()
                item.count = updatedArray.count + 1
                item.ID = updatedArray.ID
                item.germanText = updatedArray.germanText
                item.englishText = updatedArray.englishText
                item.completed = updatedArray.completed
                
                if item.count < 4 && item.completed == false {
                    RealmManager.sharedInstance.addData(object: item)
                } else if item.count == 4 {
                    item.completed = true
                    RealmManager.sharedInstance.addData(object: item)
                    let completedAnswers = RealmManager.sharedInstance.getCompletedFromRealm()
                    if completedAnswers == totalCount {
                        successfullyCompleted()
                        restart()
                    }
                }
            } else {
                wrongCounter  = wrongCounter - 1
                let item = VocabuloryItem()
                item.count = updatedArray.count - 1
                item.ID = updatedArray.ID
                item.germanText = updatedArray.germanText
                item.englishText = updatedArray.englishText
                item.completed = updatedArray.completed
                
                RealmManager.sharedInstance.addData(object: item)
                ProgressHUD.showError()
                self.showToast(message: "WRONG")
            }
            index = index + 1
            setupView()
        } else {
            let correctCount = RealmManager.sharedInstance.getCorrectAnswersFromRealm()
            if correctCount == totalCount
            {
                submitButton.setTitle("Restart",for: .normal)
                self.englishTranslationTextField.text = ""
                self.restart()
            } else {
                submitButton.setTitle("Restart",for: .normal)
                self.englishTranslationTextField.text = ""
                self.restart()
            }
        }
    }
}

extension VocabuloryViewController {
    func showAlertWithMessage(message: String, title: String) {
        let alert = UIAlertController(title: "My First Lesson", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: title, style: .default , handler:{ (UIAlertAction)in
            self.setupView()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: {
        })
    }
}
