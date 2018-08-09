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

// MARK: Model

class VocabuloryViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var LessonTitleLabel: UILabel!
    @IBOutlet weak var germanTxtLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var englishTranslationTextField: UITextField!
    
    // create csv
    var itemCSV  = VocabuloryItem()
    
    // Required declarations
    let item  = VocabuloryItem()
    let listItems = List<VocabuloryItem>()
    let csvString = "German;English;Count\nTisch;table;0\n Wetter;weather;0\n Fahrrad;bicycle;0"
    var parsedCSV = Array<Dictionary<String, Any>>()
    var index = 0, totalCount = 0, completedCycle = 0, correctCounter = 0, wrongCounter = 0
    
    // German English Words for creating csv file
    let germanWords = ["Tisch", "Wetter", "Fahrrad"]
    let EnglishWords = ["table", "weather", "bicycle"]
    
    var itemArray = [VocabuloryItem]()
    var updatedArray = List<VocabuloryItem>()
    
    
    var listView = [String]()
    var FinalArray = [[String]]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        creatCSV(filename: "FirstLesson")
        readCsv(filename: "FirstLesson")
        self.csvData()
        
        // Download file using download Manager
        DownloadManager.shared.downloadFile(url: "Testing String")
        
        if !UserDefaults.standard.bool(forKey: "Inserted") {
            csv(data: csvString)
        }
        totalCount = RealmManager.sharedInstance.getDataFromRealm().count
        self.setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction Submit
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
    
    // MARK: Setup View
    func setupView() {
        self.LessonTitleLabel.text = ""
        self.englishTranslationTextField.text = ""
        submitButton.setTitle("submit",for: .normal)
        
        if index < totalCount  {
            let updatedArray = RealmManager.sharedInstance.getItemFromRealmById(id: index)
            print("Setup: \(updatedArray)")
            self.germanTxtLabel.text = updatedArray.germanText
            self.scoreLabel.text = String(format: "Score: %@", String(updatedArray.count))
        } else {
            submitButton.setTitle("Restart",for: .normal)
            self.germanTxtLabel.text = ""
            self.scoreLabel.text = String(format: "Score: %@", "Zero")
            restart()
        }
    }
    
    // MARK: BusinessLogic
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
        //        completedCycle = completedCycle + 1
        correctCounter = 0
        wrongCounter = 0
    }
    
    // TODO: Move to CSV Handler
    // MARK: CSV Handler
    func csvData() {
        
        //checking if file exists
        let fileName = "FirstLesson"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let filePath = path?.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath!)
        {
            //file exists
            self.readCsv(filename: "FirstLesson.csv")
        }
        else
        {
            //file do not exists
//            self.showToast(message: "mynewcsv file Do not exists")
        }
    }
    
    func createFile() {
        let fileName = "FirstLesson"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        print("File PAth: \(fileURL.path)")
    }
    
    func readCsv(filename: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                //BackGround Queue Update
                let data = self.readDataFromCSV(fileName: filename, fileType: "csv")
                var csvRows = self.csvPars(data: data!)
                
                //removing header and extra Appended value
                csvRows.remove(at: csvRows.count-1)
                csvRows.remove(at: 0)
                
                //getting string format values to array
                for count in 0..<csvRows.count {
                    self.listView = csvRows[count]
                    let stringMessage = self.listView[0]
                    let DetailNewArray = stringMessage.components(separatedBy: ",")
                    self.FinalArray.append(DetailNewArray)
                    print("I am Done \(self.FinalArray)")
                }
        }
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!
    {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        let dirPath          = paths.first
        
        let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent("\(fileName).\(fileType)")
        
        do
        {
            let contents = try String(contentsOfFile: imageURL.path, encoding: .utf8)
            return contents
        }
        catch
        {
            print("File Read Error for file \(imageURL.path)")
            return nil
        }
    }
    
    func parseCSV (data: String) -> [[CustomStringConvertible]] {
        let parsedCSV: [[CustomStringConvertible]] = data
            .components(separatedBy: "\n")
            .map({
                $0.components(separatedBy: ";")
                    .map({
                        if let int = Int($0) {
                            return int
                        } else if let double = Double($0) {
                            return double
                        }
                        return $0
                    })
            })
        return parsedCSV
    }
    
    func csv(data: String) {
        //        var result: [[String]] = []
        //        var dict = Dictionary<String, Any>()
        //        var model = [dict]
        //        var key1 = ""
        //        var key2 = ""
        //        var key3 = ""
        let rows = data.components(separatedBy: "\n")
        
        for index in 0..<rows.count {
            let columns = rows[index].components(separatedBy: ";")
            
            if index == 0 {
                
                //                key1 = columns[0]
                //                key2 = columns[1]
                //                key3 = columns[2]
            }
            else {
                
                //                dict[key1] = columns[0]
                //                dict[key2] = columns[1]
                //                dict[key3] = columns[2]
                
                //realm
                let item = VocabuloryItem()
                item.germanText = columns[0]
                item.englishText = columns[1]
                item.count = Int(columns[2]) ?? 0
                item.ID = index - 1
                listItems.append(item)
            }
        }
        RealmManager.sharedInstance.addList(objects: listItems)
        UserDefaults.standard.set(true, forKey: "Inserted")
        UserDefaults.standard.synchronize()
        print("listItems: \(listItems)")
    }
    
    func SaveNewRecord() {
        
        //create a path for file
        let text:String = "mynewcsv"
        let fileName = "\(text.lowercased()).csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let filePath = path?.path
        let fileManager = FileManager.default
        
        //check if file exists or not
        if fileManager.fileExists(atPath: filePath!)
        {
            //yes file is available so need to update
            //    self.Detail = DetailToStore()
            //for loop to allocate data
            for index in 0..<germanWords.count{
                itemCSV.germanText = germanWords[index]
                itemCSV.englishText = EnglishWords[index]
                itemCSV.count = 0
                
                self.itemArray.append(itemCSV)
            }
            
            //Update CSV file
            self.updateCsvFile(filename: text.lowercased())
        }
        else
        {
            //file do not exist need to create a new file
            //for loop to allocate data
            for index in 0..<germanWords.count{
                itemCSV.germanText = germanWords[index]
                itemCSV.englishText = EnglishWords[index]
                itemCSV.count = 0
                self.itemArray.append(itemCSV)
            }
            //Create a new CSV file
            self.creatCSV(filename: text.lowercased())
        }
    }
    
    func updateCsvFile(filename: String) -> Void {
        
        //Name for file
        let fileName = "\(filename).csv"
        
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        //Loop to save array //details below header
        for item in itemArray
        {
            let newLine = "\(item.germanText),\(item.englishText),\(item.count)\n"
            
            //Saving handler
            do
            {
                //save
                try newLine.appendToURL(fileURL: path!)
                //            showToast(message: "Record is saved")
            }
            catch
            {
                //if error exists
                print("Failed to create file")
                print("\(error)")
            }
            print(path ?? "not found")
        }
    }
    
    // MARK: CSV file creating
    func creatCSV(filename: String) -> Void
    {
        //Name for file
        let fileName = "\(filename).csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        //Headers for file
        var csvText = "German,English,Count\n"
        
        //Loop to save array //details below header
        for item in itemArray
        {
            let newLine = "\(item.germanText),\(item.englishText),\(item.count)\n"
            csvText.append(newLine)
        }
        //Saving handler
        do
        {
            //save
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            showToast(message: "csv is saved")
        }
        catch
        {
            //if error exists
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    //Mark: UIAlert
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

extension VocabuloryViewController {
    func csvPars(data: String) -> [[String]]
    {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
}
