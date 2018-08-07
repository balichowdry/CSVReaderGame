//
//  Downloader.swift
//  Vocabulory Trainer
//
//  Created by BilalSattar on 07/08/2018.
//  Copyright © 2018 BilalSattar. All rights reserved.
//

import Foundation
import Alamofire

class Downloader {
    func downloader()  {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("file.csv")
            return (documentsURL, [.removePreviousFile])
        }

        Alamofire.download("", to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
            }
        }
    }
}
