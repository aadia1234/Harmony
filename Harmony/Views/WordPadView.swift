//
//  WordPadView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI

struct WordPadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var wordPad: WordPad
    
    var body: some View {
        Text("WordPad View")
            .navigationTitle(wordPad.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {}
            .onAppear { wordPad.lastOpened = Date.now }
            .onDisappear { DataController.save() }
    }
        
}

struct WordPadView_Previews: PreviewProvider {
    static var previews: some View {
        WordPadView(wordPad: WordPad())
    }
}
