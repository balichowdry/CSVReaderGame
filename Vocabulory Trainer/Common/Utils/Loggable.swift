//
//  Loggable.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 09/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation

protocol Loggable {
  /**
   Define this in your conformant class to locally control logging
   */
  var isLoggingEnabled: Bool { get }

  func debugLog(_ format: String, _ args: CVarArg...)
}

extension Loggable {
  /**
   Do not just change this to true here, but rather implement this is your class - returning true where you want logging
   */
  var isLoggingEnabled: Bool { get { return false } }
  
  /**
   Will print to the console only if DEBUG, and isLoggingEnabled is true
   */
  func debugLog(_ format: String, _ args: CVarArg...) {
    if (isLoggingEnabled) {
      #if DEBUG
        if args.count > 0 {
          print(String(format: format, arguments: args))
        } else {
          print(format)
        }
      #endif
    }
  }
}
