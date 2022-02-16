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
                    note.thumbnailData = canvasView.getThumbnail().pngData()!
                    note.drawingData = canvasView.getCanvasDrawing().dataRepresentation()
                    self.presentationMode.wrappedValue.dismiss()
                    DataController.save()
                } label: { Label("Documents", systemImage: "chevron.left") }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { canvasView.toggleToolPicker() } label: { Image(systemName: "pencil") }
                Button { canvasView.clearCanvas() } label: { Image(systemName: "trash") }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            canvasView.setCanvasDrawing(data: note.drawingData)
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