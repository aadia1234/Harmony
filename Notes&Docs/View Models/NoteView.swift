//
//  NoteView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var updateView: UpdateView

    @State private var canvasView = CanvasView()
    @State var note: Note
    
    
    var body: some View {
        ZoomableScrollView {
            canvasView
                .scaleEffect()
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .opacity(updateView.didUpdate ? 0 : 1)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    note.preview = canvasView.getPreview()
                    note.drawing = canvasView.getCanvasDrawing()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Documents")
                    }
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    canvasView.toggleToolPicker()
                } label: {
                    Image(systemName: "pencil")
                }
                
                Button {
                    canvasView.clearCanvas()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            canvasView.setCanvasDrawing(note.drawing)
            note.lastOpened = Date.now
        }
            
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: Note())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
