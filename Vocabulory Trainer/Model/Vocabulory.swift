//
//  Vocabulory.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 09/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import UIKit
import RealmSwift

class Vocabulory: Object {
    
    @objc dynamic var VocabuloryName : String?
//    dynamic var createdDate : Date?
    let vocabuloryItems = List<VocabuloryItem>()
}
