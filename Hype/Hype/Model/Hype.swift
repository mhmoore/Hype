//
//  Hype.swift
//  Hype
//
//  Created by Michael Moore on 8/26/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    
    static let recordTypeKey = "Hype"
    static let recordTextKey = "Text"
    static let recordTimestampKey = "Timestamp"
}

class Hype {
    
    var hypeText: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID?
    
    init(hypeText: String, timestamp: Date = Date()) {
        self.hypeText = hypeText
        self.timestamp = timestamp 
    }
}

extension CKRecord {
    // Create a CKRecord from a Hype (a.k.a saving)
    // CKRecord is a dictionary.  Taking the values of Hype and setting them to the keys of the CKRecord
    convenience init(hype: Hype) {
        // self.init is for Apple's CKRecord.  We want our custom record with the existing record ID or to create a new record when a new Hype is made
        let recordID = hype.ckRecordID ?? CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: Constants.recordTypeKey, recordID: hype.ckRecordID ?? CKRecord.ID(recordName: UUID().uuidString))
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timestamp, forKey: Constants.recordTimestampKey)
        // Important: since we're inside an extension
        hype.ckRecordID = recordID
    }
}

extension Hype {
    // Creating a Hype from a CKRecord (a.k.a loading)
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String,
            let timestamp = ckRecord[Constants.recordTimestampKey] as? Date else { return nil }
        self.init(hypeText: hypeText, timestamp: timestamp)
        // makes sure you are fetching the correct records, which you can later delete and/or update
        ckRecordID = ckRecord.recordID
    }
}

extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
       return lhs.hypeText == rhs.hypeText &&
            lhs.timestamp == rhs.timestamp &&
            lhs.ckRecordID == rhs.ckRecordID
    }
    

}

