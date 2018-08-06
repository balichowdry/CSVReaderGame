//
//  Data+Append.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 05/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation

//MARK: Extension for File data
extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
