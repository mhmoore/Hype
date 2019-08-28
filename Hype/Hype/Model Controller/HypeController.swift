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
        self.hypes.insert(hype, at: 0)
        publicDB.save(hypeRecord) { (_, error) in
            if let error = error {
                print("There was an error in \(#function). \(String(describing: error)): \(error.localizedDescription)")
                completion(false)
                return
            }
        }
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
    func update(hype: Hype, with newText: String, completion: @escaping (Bool) -> Void) {
        hype.hypeText = newText
        hype.timestamp = Date()
        
        let modificationOp = CKModifyRecordsOperation(recordsToSave: [CKRecord(hype:hype)], recordIDsToDelete: nil)
        modificationOp.savePolicy = .changedKeys
        modificationOp.queuePriority = .veryHigh
        modificationOp.qualityOfService = .userInteractive
        modificationOp.modifyRecordsCompletionBlock = { (_, _, error) in
            if let error = error {
                print("There was an error in \(#function). \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
        publicDB.add(modificationOp)
    }
    
    // delete
    func remove(hype: Hype, completion: @escaping (Bool) -> Void) {
        // get the recordID that needs to be deleted
        guard let hypeRecord = hype.ckRecordID,
            // conform to equatable to get firstIndex of method
            let firstIndex = self.hypes.firstIndex(of: hype) else { return }
        // remove from your SoT
        hypes.remove(at: firstIndex)
        publicDB.delete(withRecordID: hypeRecord) { (recordID, error) in
            if let error = error {
                print("There was an error deleting. \(error): \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // CKSubscribe
    func subscribeToRemoteNotifications(completion: @escaping (Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: Constants.recordTypeKey, predicate: predicate, options: [.firesOnRecordCreation, .firesOnRecordDeletion])
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "Hell yeah! New Hypes!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("There was an error in \(#function). \(error): \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
