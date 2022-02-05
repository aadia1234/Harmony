//
//  CanvasView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/19/22.
//

import SwiftUI
import PencilKit

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
  private var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true

    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)

    return scrollView
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content))
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
  }

  // MARK: - Coordinator

  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>

    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
  }
}


struct CanvasView: UIViewRepresentable {
    @State private var canvas = PKCanvasView()
    @State private var toolpicker = PKToolPicker()

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pen, color: .black, width: 10)
        toggleToolPicker()
        
        return canvas
    }
    
    func toggleToolPicker() {
        toolpicker.setVisible(!toolpicker.isVisible, forFirstResponder: canvas)
        toolpicker.addObserver(canvas)
        canvas.becomeFirstResponder()
    }
    
    func setCanvasDrawing(_ drawing: PKDrawing) {
        canvas.drawing = drawing
    }
    
    func clearCanvas() {
        canvas.drawing = PKDrawing()
    }
    
    func getPreview() -> Image {
        return Image(uiImage: canvas.drawing.image(from: canvas.bounds, scale: 1.0))
    }
    
    func getCanvasDrawing() -> PKDrawing {
        return canvas.drawing
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}


struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
