//
//  WordPadView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI

struct WordPadView: View {
    @ObservedObject var wordPad: WordPad
    @ObservedObject var controller = TextEditorViewController()

    @State private var fontName = "Arial"
    @State private var fontSize = 18.0
    
    @State private var str = AttributedString("New ewwewePage")
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    VStack {
                        ForEach(0..<controller.pageCount, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10 * controller.zoomScale) 
                                .foregroundColor(Color(uiColor: .systemGray5))
                                .padding(.bottom, 50 * controller.zoomScale)
                        }
                    }
                    
                    TextEditorView(wordPad: wordPad, controller: controller, tag: 0)
                }
                .frame(width: 800*controller.zoomScale, height: 800*sqrt(2)*controller.zoomScale*Double(controller.pageCount) + Double(controller.pageCount-1)*controller.zoomScale*50, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
        }
        .navigationTitle(wordPad.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { controller.wordPad = wordPad; str.foregroundColor = .white; str.font = .system(size: 18) }
        .onDisappear {
            wordPad.date = Date.now
            DataController.save()
        }
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                Menu {
//                    LabelButton(title: "Insert Image", image: "photo") {}
//                } label: { Label("Insert", systemImage: "plus") }
//                
//                Menu {
//                    
//                } label: { Label("Text Attributes", systemImage: "textformat.size") }
//                
//                Menu {
//                    LabelButton(title: "Export as PDF", image: "doc.richtext") {}
//                } label: { Label("Export", systemImage: "square.and.arrow.up") }
//                
//                Menu {
//                    
//                } label: { Label("Settings", systemImage: "ellipsis.circle") }
//            }
//        }
    }
        
}

struct WordPadView_Previews: PreviewProvider {
    static var previews: some View {
        WordPadView(wordPad: WordPad())
    }
}
