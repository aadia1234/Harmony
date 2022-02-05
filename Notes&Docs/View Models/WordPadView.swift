//
//  WordPadView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI

struct WordPadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var updateView: UpdateView

    @State private var canvasView = CanvasView()
    @State var wordPad: WordPad
    
    var body: some View {
        Text("e")
            .navigationTitle(wordPad.title)
            .navigationBarTitleDisplayMode(.inline)
            .opacity(updateView.didUpdate ? 0 : 1)
//            .navigationBarHidden(true)
            .toolbar {
                
            }
            .onAppear {
                wordPad.lastOpened = Date.now
            }
    }
        
}

struct WordPadView_Previews: PreviewProvider {
    static var previews: some View {
        WordPadView(wordPad: WordPad())
    }
}
