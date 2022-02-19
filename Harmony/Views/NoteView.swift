//
//  NoteView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var canvasView = CanvasView()
    @ObservedObject var note: Note
    @Binding var thumbnail: Image
    
    var body: some View {
        canvasView
        .scaleEffect()
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button { canvasView.toggleToolPicker() } label: { Image(systemName: "pencil") }
                Button { canvasView.clearCanvas() } label: { Image(systemName: "trash") }
            }
        }
        .onDisappear {
            note.thumbnailData = canvasView.getThumbnail().pngData()!
            note.drawingData = canvasView.getCanvasDrawing().dataRepresentation()
            thumbnail = Image(uiImage: UIImage(data: note.thumbnailData!)!)
            note.drawingHeight = canvasView.canvas.contentSize.height
            DataController.save()
        }
        .onAppear {
            canvasView.setCanvasDrawing(data: note.drawingData, height: note.drawingHeight)
            note.lastOpened = Date.now
        }
            
    }
}

//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteView(note: Note())
//            .previewInterfaceOrientation(.landscapeLeft)
//    }
//}
