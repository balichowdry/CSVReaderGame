//
//  CSVHandler.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 11/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation
import RealmSwift

class CSVHandler {
    
    static let sharedInstance = CSVHandler()
    var listView = [String]()
    let listItems = List<VocabuloryItem>()
    var FinalArray = [[String]]()
    
    func csvData() {
        
        let fileName = Constants.filename
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let filePath = path?.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath!)
        {
            self.readCsv(filename: Constants.filename)
        }
    }
    
    func createFile() {
        let fileName = Constants.filename
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        print("File PAth: \(fileURL.path)")
    }
    
    func readCsv(filename: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let data = self.readDataFromCSV(fileName: filename, fileType: "csv")
                var csvRows = self.csvPars(data: data!)
                
                csvRows.remove(at: csvRows.count-1)
                csvRows.remove(at: 0)
                
                for count in 0..<csvRows.count {
                    self.listView = csvRows[count]
                    let stringMessage = self.listView[0]
                    let DetailNewArray = stringMessage.components(separatedBy: ",")
                    self.FinalArray.append(DetailNewArray)
                }
        }
    }
    
    func readDataFromCSV(fileName:String, fileType: String) -> String?
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
            return ""
        }
    }
    
    func csv(data: String) {
        let rows = data.components(separatedBy: "\n")
        
        for index in 0..<rows.count {
            let columns = rows[index].components(separatedBy: ";")
            
            if index == 0 {
            }
            else {
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
    }
    
    func creatCSV(filename: String) -> Void
    {
        let fileName = "\(filename).csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        let csvText = Constants.tempCSVData
        do
        {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        }
        catch
        {
            print("Failed to create file")
        }
    }
}

extension CSVHandler {
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
