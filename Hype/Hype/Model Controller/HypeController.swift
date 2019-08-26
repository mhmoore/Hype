//
//  HypeController.swift
//  Hype
//
//  Created by Michael Moore on 8/26/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    static let shared = HypeController()
    
    var hypes: [Hype] = []
    
    let publicDB = CKContainer(identifier: "iCloud.com.michaelhmoore.Hype").publicCloudDatabase
    
    // CRUD
    // create
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        let hype = Hype(hypeText: text)
        let hypeRecord = CKRecord(hype: hype)
        
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("There was an error in \(#function). \(String(describing: error)): \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        hypes.append(hype)
        completion(true)
    }
    
    
    
    // read
    
    func fetchHypes(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error in \(#function). \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let hypes = records.compactMap( {Hype(ckRecord: $0)} ) // == for-in loop with the added check of nil
            self.hypes = hypes
            completion(true)
        }

    }
    
    // update
    
    // delete
    
    
}
