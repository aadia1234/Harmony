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

    @State var wordPad: WordPad
    
    var body: some View {
        Text("WordPad View")
            .navigationTitle(wordPad.title)
            .navigationBarTitleDisplayMode(.inline)
            .opacity(updateView.didUpdate ? 0 : 1)
            .navigationBarHidden(true)
            .toolbar {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                    DataController.save()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Documents")
                    }
                }
            }
            .onAppear { wordPad.lastOpened = Date.now }
    }
        
}

struct WordPadView_Previews: PreviewProvider {
    static var previews: some View {
        WordPadView(wordPad: WordPad())
    }
}
