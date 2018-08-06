////
////  CSVHandler.swift
////  Vocabulory Trainer
////
////  Created by BilalSattar on 05/08/2018.
////  Copyright © 2018 BilalSattar. All rights reserved.
////
//
//import Foundation
//
//func csv(data: String) {
//    //        var result: [[String]] = []
//    //        var dict = Dictionary<String, Any>()
//    //        var model = [dict]
//    //        var key1 = ""
//    //        var key2 = ""
//    //        var key3 = ""
//    let rows = data.components(separatedBy: "\n")
//    
//    for index in 0..<rows.count {
//        let columns = rows[index].components(separatedBy: ";")
//        
//        if index == 0 {
//            
//            //                key1 = columns[0]
//            //                key2 = columns[1]
//            //                key3 = columns[2]
//        }
//        else {
//            
//            //                dict[key1] = columns[0]
//            //                dict[key2] = columns[1]
//            //                dict[key3] = columns[2]
//            
//            //realm
//            let item = VocabuloryItem()
//            item.germanText = columns[0]
//            item.englishText = columns[1]
//            item.count = Int(columns[2]) ?? 0
//            item.ID = index - 1
//            listItems.append(item)
//        }
//        
//    }
//    RealmManager.sharedInstance.addList(objects: listItems)
//    UserDefaults.standard.set(true, forKey: "Inserted")
//    UserDefaults.standard.synchronize()
//    print("listItems: \(listItems)")
//}
//    
