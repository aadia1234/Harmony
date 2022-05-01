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
    public var pages: [Page] {
        get {
            let p = self.storedPages?.allObjects as? [Page]
            return p?.sorted {$0.index < $1.index} ?? [Page(text: "", index: -1)]
        }
        set {self.storedPages = NSSet(array: newValue)}}

    convenience init(title: String, pages: [Page], thumbnailData: Data?, lastOpened: Date, text: String) {
        self.init()
        self.title = title
        self.thumbnailData = thumbnailData
        self.date = lastOpened
        self.pages = pages
        
    }
}
