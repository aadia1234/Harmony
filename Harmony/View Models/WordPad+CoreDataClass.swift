//
//  WordPad+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import Foundation
import CoreData

@objc(WordPad)
public class WordPad: Document {
    public var text: String { get {self.storedText ?? "text"} set {self.storedText = newValue} }

    convenience init(title: String, thumbnailData: Data?, lastOpened: Date, text: String) {
        self.init()
        self.title = title
        self.thumbnailData = thumbnailData
        self.lastOpened = lastOpened
        self.text = text
    }
}
