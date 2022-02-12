//
//  Document+CoreDataClass.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/11/22.
//
//

import SwiftUI
import CoreData
import UIKit

@objc(Document)
public class Document: Item {
    public var thumbnailData: Data? { get {self.storedThumbnailData} set {self.storedThumbnailData = newValue}}
    public var lastOpened: Date { get {self.storedLastOpened ?? Date.now} set {self.storedLastOpened = newValue}}
    public var folder: Folder { get {self.storedFolder ?? Folder()} set {self.storedFolder = newValue}}

    convenience required init() {self.init(context: Item.context)}
    
    override func move(to folder: Folder) {
        let copy = self.copy() as! Document
        folder.addToStoredDocuments(copy)
        self.delete()
    }
}
