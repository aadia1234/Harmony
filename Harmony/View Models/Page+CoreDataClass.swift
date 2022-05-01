//
//  Page+CoreDataClass.swift
//  Harmony
//
//  Created by Aadi Anand on 3/15/22.
//
//

import SwiftUI
import CoreData

@objc(Page)
public class Page: NSManagedObject {
    public var text: NSAttributedString { get {self.storedText ?? NSAttributedString(string: "New Page")} set {self.storedText = newValue}}
    public var index: Int { get {Int(self.storedIndex)} set {self.storedIndex = Int16(newValue)}}
    
    convenience init(text: NSAttributedString, index: Int) {
        self.init(context: DataController.context)
        self.text = text
        self.index = index
        DataController.save()
    }
    
    convenience init(text: String, index: Int) {
        self.init(context: DataController.context)
        let paragraphStyle = NSMutableParagraphStyle()
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.label, .paragraphStyle: paragraphStyle
        ]
//        paragraphStyle.paragraphSpacing = 50
        paragraphStyle.lineSpacing = 1
        
        self.text = NSAttributedString(string: text, attributes: attrs)
        self.index = index
        DataController.save()
    }
}
