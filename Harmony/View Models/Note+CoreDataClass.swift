//
//  Note+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 2/15/22.
//
//

import SwiftUI
import PencilKit
import CoreData

@objc(Note)
public class Note: Document {
    public var drawingData: Data? { get {self.storedDrawingData} set {self.storedDrawingData = newValue}}
        
    convenience init(title: String, thumbnailData: Data?, lastOpened: Date, drawingData: Data?) {
        self.init()
        self.title = title
        self.thumbnailData = thumbnailData
        self.lastOpened = lastOpened
        self.drawingData = drawingData
    }
}
