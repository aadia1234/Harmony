//
//  LabelButton.swift
//  Harmony
//
//  Created by Aadi Anand on 2/25/22.
//

import SwiftUI

struct LabelButton: View {
    public let labelName: String
    public let imageName: String?
    public let buttonRole: ButtonRole?
    public let action: () -> Void
    
    init(title labelName: String? = nil, image imageName: String? = nil, role buttonRole: ButtonRole? = nil, action: @escaping () -> Void) {
        self.labelName = labelName ?? ""
        self.imageName = imageName
        self.buttonRole = buttonRole
        self.action = action
    }
    
    var body: some View {
        Button(role: buttonRole, action: action) {
            if let imageName = imageName {
                Label(labelName, systemImage: imageName)
            } else {
                Text(labelName)
            }
        }
        .font(buttonRole == .cancel ? .body.bold() : .body)
        .foregroundColor(buttonRole == .destructive ? .red : .accentColor)
        .buttonStyle(.automatic)
    }
}

//struct LabelButton_Previews: PreviewProvider {
//    static var previews: some View {
//        LabelButton()
//    }
//}
