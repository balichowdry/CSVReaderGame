//
//  RealmManager.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 04/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    
    private var realm:Realm
    static let sharedInstance = RealmManager()
    
    private init() {
        realm = try! Realm()
    }
    
    func getDataFromRealm() -> Results<VocabuloryItem> {
        let results: Results<VocabuloryItem> = realm.objects(VocabuloryItem.self)
//        let unFinishedAns = results.filter{$0.completed == false }
        return results
    }
    
    func getCompletedFromRealm() -> Int {
        let results: Results<VocabuloryItem> = realm.objects(VocabuloryItem.self)
        let completedAns = results.filter{$0.completed == true}
        return completedAns.count
    }
    
    func getCorrectAnswersFromRealm() -> Int {
        
        let items = realm.objects(VocabuloryItem.self)
        let correctAnswers = items.filter{$0.count >= 4}
        
        return correctAnswers.count
    }
    
    func getWrongAnswersFromRealm() -> Int {
        
        let items = realm.objects(VocabuloryItem.self)
        let wrongAnswers = items.filter{$0.count <= 0}
        
        return wrongAnswers.count
    }
    
    func getItemFromRealmById(id: Int) -> VocabuloryItem {
        
        let realm = try! Realm()
        return realm.object(ofType: VocabuloryItem.self, forPrimaryKey: id)!
    }
    
    func updateItemFromID(object: VocabuloryItem) {
        
        try! realm.write {
            realm.add(object, update: true)
            print("updated object")
        }
    }
    
    func addData(object: VocabuloryItem) {
        
        try! realm.write {
            realm.add(object, update: true)
            print("Added new object")
        }
    }
    
    func addList(objects: List<VocabuloryItem>) {
        try! realm.write {
            realm.add(objects, update: true)
            print("Added new object")
        }
    }
    
    func deleteAllDatabase()  {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteFromRealm(object: VocabuloryItem) {
        
        try! realm.write {
            let result = realm.objects(VocabuloryItem.self)
            realm.delete(result)
        }
    }
    
}
