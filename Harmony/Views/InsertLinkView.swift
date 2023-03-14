//
//  InsertLinkView.swift
//  Harmony
//
//  Created by Aadi Anand on 2/23/23.
//

import SwiftUI

struct InsertLinkView: View {
    @Binding public var url: String
    @Binding public var displayText: String
    @State private var buttonClicked = false
    @EnvironmentObject var updateView: UpdateView
    
    private var visibility: Bool { return updateView.showEditorAlert && type(of: updateView.editorAlert) == InsertLinkView.self }
    
    var body: some View {
        HStack {
            VStack {
                Text("Insert/Edit Link")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Divider()
                
                TextField("URL", text: $url)
                    .font(.system(size: 15))
                    .padding(10)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding([.top, .bottom], 5)
                
                TextField("Text to display", text: $displayText)
                    .font(.system(size: 15))
                    .padding(10)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding([.top, .bottom], 5)
                
                Divider()
                
                HStack {
                    LabelButton(title: "Cancel", role: .cancel) {
                        updateView.showEditorAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .hoverEffect(.automatic)
                    
                    Divider()
                    
                    LabelButton(title: "OK") {
                        buttonClicked.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .hoverEffect(.automatic)
                }
                .frame(height: 40)
            }
        }
        .padding([.trailing, .leading], 16)
        .padding([.top, .bottom], 8)
        .frame(maxWidth: 400, minHeight: 190)
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .background(.thickMaterial)
        )
        .onAppear {
//            url = ""
//            displayText = ""
        }
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .opacity(visibility ? 1 : 0)
        .modifier(ShakeEffect(shakes: ((url.isEmpty || displayText.isEmpty) && buttonClicked) ?  2 : 0))
        .animation(.linear(duration: 0.5), value: buttonClicked)
        .disabled(!visibility)
    }
}

struct InsertLinkView_Previews: PreviewProvider {
    static var previews: some View {
        InsertLinkView(url: .constant(""), displayText: .constant(""))
    }
}
