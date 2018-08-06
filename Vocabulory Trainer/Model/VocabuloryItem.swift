//
//  VocabuloryItem.swift
//  RealmSwift
//
//  Created by Riccardo Rizzo on 12/07/17.
//  Copyright © 2017 Riccardo Rizzo. All rights reserved.
//

import UIKit
import RealmSwift

class VocabuloryItem: Object {
    
    @objc dynamic var ID = 0
    @objc dynamic var germanText = ""
    @objc dynamic var englishText = ""
    @objc dynamic var count = 0
    @objc dynamic var completed = false
    override static func primaryKey() -> String? {
        return "ID"
    }
    
}
