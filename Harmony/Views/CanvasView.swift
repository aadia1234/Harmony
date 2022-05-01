//
//  CanvasView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/19/22.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    let controller = CanvasController()
    let toolpicker = PKToolPicker()
    let canvas = PKCanvasView()
    var background = UIImage(color: .red)

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pen, color: .black, width: .greatestFiniteMagnitude)
        canvas.contentSize.width = UIScreen.main.bounds.width
        canvas.showsHorizontalScrollIndicator = false
        canvas.maximumZoomScale = 10.0
        canvas.minimumZoomScale = 1.0
        canvas.delegate = controller
        canvas.backgroundColor = .clear
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = background
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFit
        canvas.insertSubview(backgroundImage, at: 0)
        
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
    
    mutating func setBackground(_ background: UIImage) {
//        (canvas.subviews[0] as! UIImageView).image = background
        for view in canvas.subviews {
            (view as! UIImageView).image = background
        }
    }
    
    func clearCanvas() {
        canvas.drawing = PKDrawing()
        canvas.contentSize.height = UIScreen.main.bounds.height
    }
    
    func getThumbnail() -> UIImage {
        return canvas.drawing.image(from: UIScreen.main.bounds, scale: 1.0)
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}


//struct CanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        CanvasView()
//    }
//}
