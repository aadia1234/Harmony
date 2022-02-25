//
//  SortMethod.swift
//  Harmony
//
//  Created by Aadi Anand on 2/25/22.
//

import Foundation

public enum SortMethod: String, CaseIterable, Identifiable {
    case name = "name"
    case date = "date"
    case type = "type"
    
    public var id: String { self.rawValue }
}
