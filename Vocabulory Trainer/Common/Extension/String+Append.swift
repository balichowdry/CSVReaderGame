//
//  String+Append.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 05/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation
//MARK: Extension for String
extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        var data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}
