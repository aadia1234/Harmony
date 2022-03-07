//
//  SortMethod.swift
//  Harmony
//
//  Created by Aadi Anand on 2/25/22.
//

import Foundation

public enum SortMethod: String, CaseIterable, Identifiable {
    case title = "Title"
    case date = "Date"
    case type = "Type"
    
    public var id: String { self.rawValue }
}
