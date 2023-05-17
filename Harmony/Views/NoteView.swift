//
//  NoteView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI
import PhotosUI
import PSPDFKit
import PSPDFKitUI



public extension UIImage {
      convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
      }
    }

struct NoteView: View {
    @State private var canvasView = CanvasView()
    @ObservedObject var note: Note
    @Binding var thumbnail: Data
    
    @State private var backgroundImage: UIImage?
    @State private var showImagePicker = false
    @State private var imageView: Image?
    
    let fileURL = Bundle.main.url(forResource: "bitcoin", withExtension: "pdf")!
    
    var body: some View {
        PDFView(document: PSPDFKitUI.Document(url: fileURL))
            .useParentNavigationBar(true)
            .edgesIgnoringSafeArea(.all)
//        canvasView
//        .navigationTitle(note.title)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
////                LabelButton(title: "Change background", image: "photo.on.rectangle") {
////                    showImagePicker.toggle()
////                }
//                LabelButton(title: "Show pencil", image: "pencil") { canvasView.toggleToolPicker() }
//                LabelButton(title: "Delete canvas", image: "trash", role: .destructive) { canvasView.clearCanvas() }
//            }
//        }.onChange(of: backgroundImage, perform: { _ in
//            guard let backgroundImage = backgroundImage else { return }
//            imageView = Image(uiImage: backgroundImage)
//            canvasView.setBackground(backgroundImage)
//        })
//        .onDisappear {
//            note.thumbnailData = canvasView.getThumbnail().pngData()!
//            note.drawingData = canvasView.canvas.drawing.dataRepresentation()
//            note.drawingHeight = canvasView.canvas.contentSize.height
//            note.date = Date.now
//            thumbnail = note.thumbnailData!
//            DataController.shared.save()
//        }
//        .onAppear { canvasView.setCanvasDrawing(data: note.drawingData, height: note.drawingHeight) }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(image: $backgroundImage)
//        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    private static let data = UIImage(systemName: "pencil")!.pngData()!
    static var previews: some View {
        NavigationStack {
            NoteView(note: Note(title: "test", thumbnailData: data, lastOpened: Date.now, drawingData: nil), thumbnail: .constant(data))
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
