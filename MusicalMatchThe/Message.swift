//
//  Message.swift
//  MusicalMatchThe
//
//  Created by Joshua Kuehn on 5/11/15.
//  Copyright (c) 2015 Joshua Kuehn. All rights reserved.
//

import Foundation

struct Message {
    var message:String
    var senderID: String
    var date: NSDate
}

class MessageListener {
    var currentHandle: UInt?
    
    init (matchID:String, startDate:NSDate, callback: (Message)-> ()) {
        let handle = ref.childByAppendingPath(matchID).queryOrderedByKey().queryStartingAtValue(dateFormatter().stringFromDate(startDate)).observeEventType(FEventType.ChildAdded, withBlock: {
            snapShot in
            let message = snapShotToMessage(snapShot)
            callback(message)
        })
        self.currentHandle = handle
    }
    
    func stop () {
        if let handle = currentHandle {
            ref.removeObserverWithHandle(handle)
            currentHandle = nil
        }
    }
}

private var ref = Firebase(url: "https://musicalmatchthe.firebaseio.com/messages")

private let dateFormat = "yyyyMMddHHmmss"

private func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

func saveMessage (matchID:String, message: Message) {
    ref.childByAppendingPath(matchID).updateChildValues([dateFormatter().stringFromDate(message.date) : ["message" : message.message, "sender" : message.senderID]])
    
}

private func snapShotToMessage (snapShot:FDataSnapshot)-> Message {
    let date = dateFormatter().dateFromString(snapShot.key)
    let sender = snapShot.value["sender"] as? String
    let text = snapShot.value["message"] as? String
    return Message(message: text!, senderID: sender!, date: date!)
}

func fetchMessages (matchID:String, callback: ([Message])->()) {
    ref.childByAppendingPath(matchID).queryLimitedToFirst(25).observeSingleEventOfType(FEventType.Value, withBlock: {
        snapShot in
        var messages = Array<Message>()
        let enumerator = snapShot.children
        while let data = enumerator.nextObject() as? FDataSnapshot {
            messages.append(snapShotToMessage(data))
        }
        callback(messages)
    })
}