//
//  EditorDataModel.swift
//  Harmony
//
//  Created by Aadi Anand on 2/24/23.
//

import SwiftUI

class EditorDataModel: ObservableObject {
    @Published public var url: String = ""
    @Published public var displayText: String = ""
}
