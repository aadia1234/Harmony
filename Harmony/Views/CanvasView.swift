//
//  CanvasView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/19/22.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @State var controller = CanvasController()
    let toolpicker = PKToolPicker()
    let canvas = PKCanvasView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pen, color: .black, width: .greatestFiniteMagnitude)
        canvas.contentSize.width = UIScreen.main.bounds.width
        canvas.showsHorizontalScrollIndicator = false
        canvas.maximumZoomScale = 10.0
        canvas.minimumZoomScale = 1.0
        canvas.delegate = controller
        toggleToolPicker()
        return canvas
    }
    
    func toggleToolPicker() {
        toolpicker.setVisible(!toolpicker.isVisible, forFirstResponder: canvas)
        toolpicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
    
    func setCanvasDrawing(data drawingData: Data? = nil, height: Double) {
        if let data = drawingData { canvas.drawing = try! PKDrawing(data: data)}
        if height == 0 {
            canvas.contentSize.height = UIScreen.main.bounds.height
        } else {
            canvas.contentSize.height = height
        }
    }
    
    func clearCanvas() {
        canvas.drawing = PKDrawing()
    }
    
    func getThumbnail() -> UIImage {
        return canvas.drawing.image(from: UIScreen.main.bounds, scale: 1.0)
    }
    
    func getCanvasDrawing() -> PKDrawing {
        return canvas.drawing
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}


//struct CanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        CanvasView()
//    }
//}
