//
//  TextEditorView.swift
//  Harmony
//
//  Created by Aadi Anand on 3/14/22.
//

import SwiftUI

public class TextEditorViewController: NSObject, UITextViewDelegate, ObservableObject {
    @Published public var zoomScale = 1.0
    @ObservedObject public var wordPad = WordPad()
    @Published public var pageCount = 1
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomScale = scrollView.zoomScale
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let rects = textView.selectionRects(for: textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)!)
        var height = 0.0
        for selectedRects in rects {
            height += selectedRects.rect.height
        }
        
        if height > 1000 {
            let newParagraphStyle = NSParagraphStyle()
        }
        
        pageCount = Int(height / 1000) + 1
        
        
        print("HEIGHT: \(height)")
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.attributedText
        if let page = wordPad.pages.first(where: {$0.index == textView.tag}) {
            page.text = text!
        } else {
            wordPad.pages.append(Page(text: text!, index: wordPad.pages.count))
        }
    }
    
    
}

struct TextEditorView: UIViewRepresentable {
    @ObservedObject public var wordPad: WordPad
    @ObservedObject public var controller: TextEditorViewController
    public let tag: Int
    public let textView = UITextView(frame: .zero)
    
    func makeUIView(context: Context) -> UITextView {
        textView.textContainerInset = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        textView.minimumZoomScale = 0.05
        textView.maximumZoomScale = 10.0
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.tag = tag
        textView.attributedText = wordPad.pages.first(where: {$0.index == tag})!.text      
        textView.bouncesZoom = true
        textView.delegate = controller
        textView.bounces = false
        textView.bouncesZoom = false
        textView.alwaysBounceVertical = false
        textView.alwaysBounceHorizontal = false
//        textView.textContainer.maximumNumberOfLines = 50
        textView.textContainer.lineBreakMode = .byClipping
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        textView.allowsEditingTextAttributes = true
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {}
}
