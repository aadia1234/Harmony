//
//  Document+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import SwiftUI
import CoreData
import UIKit

@objc(Document)
public class Document: Item {
    public var thumbnailData: Data? { get {self.storedThumbnailData} set {self.storedThumbnailData = newValue} }
    public var folder: Folder { get {self.storedFolder ?? Folder()} set {self.storedFolder = newValue} }

    convenience required init() { self.init(context: DataController.shared.context); DataController.shared.save() }
    
    override func move(to folder: Folder) {
        self.folder = folder
        super.move(to: folder)
    }
}
