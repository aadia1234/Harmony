//
//  WordPadView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 2/1/22.
//

import SwiftUI
import UIKit
import WebKit
import JavaScriptCore

struct WebViewUI: UIViewRepresentable {
    @State public var webView: WKWebView
    @State public var htmlFileName: String
    
    func makeUIView(context: Context) -> some UIView {
        webView.isOpaque = false
        return webView
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = Bundle.main.url(forResource: htmlFileName, withExtension: "html") else {
            return print("URL Error")
        }
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
}


struct CustomMenu: UIViewRepresentable {
    @State public var title: String
    @State public var icon: String
    @State public var type: UIMenu.ElementSize
    @State public var submenus: [[LabelButton]]
    
    func mapButtonActions(buttons: [LabelButton]) -> [UIAction] {
        return buttons.map { button in
            UIAction(title: button.labelName, image: UIImage(systemName: button.imageName!)) { action in
                return button.action()
            }
        }
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        var uiSubmenus: [UIMenuElement] = mapButtonActions(buttons: submenus[0])
        
        button.setImage(UIImage(systemName: icon), for: .normal)
        
        if (submenus.count > 1) {
            uiSubmenus = submenus.map {
                return UIMenu(title: "", options: .displayInline, children: mapButtonActions(buttons: $0))
            }
        }
        
        
        button.menu = UIMenu(title: "", preferredElementSize: type, children: uiSubmenus)
        button.showsMenuAsPrimaryAction = true
        
        button.isPointerInteractionEnabled = true
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {}
}



struct WordPadView: View {
    @ObservedObject var wordPad: WordPad
    @ObservedObject var controller = TextEditorViewController()
    @State private var webView = WKWebView()
    @State private var splitViewMode = UISplitViewController.DisplayMode.oneOverSecondary
    @State private var titleText = ""
    @EnvironmentObject var updateView: UpdateView
    
    @State private var setLineSpacing = false
    @State private var lineSpacing = 1.0
    
    init(wordPad: WordPad) {
        self.wordPad = wordPad
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.clear)
                WebViewUI(webView: webView, htmlFileName: "editor")
        }
        .navigationTitle(wordPad.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            controller.wordPad = wordPad;
            updateView.enableSidebar = false
        }
        .onDisappear { wordPad.date = Date.now; DataController.save(); }
        .toolbar {
            ToolbarTitleMenu {
                LabelButton(title: "Rename", image: "pencil") {}
                LabelButton(title: "Move", image: "rectangle.portrait.and.arrow.right") {}
            }
            
            ToolbarItemGroup(placement: .automatic) {
                LabelButton(title: "Back", image: "arrow.uturn.backward") { executeCommand("Undo") }
                LabelButton(title: "Forward", image: "arrow.uturn.forward") { executeCommand("Redo") }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                ControlGroup {
                    HStack {
                        CustomMenu(title: "Insert Media", icon: "plus", type: .small, submenus: [
                            [
                                LabelButton(title: "Insert Link", image: "link") {},
                                LabelButton(title: "Insert Table", image: "tablecells") {},
                                LabelButton(title: "Insert Image", image: "photo") {},
                                LabelButton(title: "Insert Video", image: "video") {},
                                LabelButton(title: "Insert Code", image: "chevron.left.forwardslash.chevron.right") {}
                            ],
                            [
                                LabelButton(title: "Special Characters", image: "character.phonetic") {},
                                LabelButton(title: "Emojis", image: "face.smiling") {}
                            ]
                        ])
                        
                        CustomMenu(title: "Text Attributes", icon: "textformat", type: .medium, submenus: [[
                            LabelButton(title: "Bold", image: "bold") { executeCommand("Bold") },
                            LabelButton(title: "Italic", image: "italic") { executeCommand("Italic") },
                            LabelButton(title: "Underline", image: "underline") { executeCommand("Underline") },
                            LabelButton(title: "Strikethrough", image: "strikethrough") { executeCommand("Strikethrough") },
                            LabelButton(title: "Superscript", image: "textformat.superscript") { executeCommand("Superscript") },
                            LabelButton(title: "Subscript", image: "textformat.subscript") { executeCommand("Subscript") },
                            LabelButton(title: "Font Format", image: "textformat.alt") {}
                        ]])
                        

                        CustomMenu(title: "Paragraph Style", icon: "paragraphsign", type: .small, submenus: [[
                            LabelButton(title: "Left", image: "text.alignleft") { executeCommand("JustifyLeft") },
                            LabelButton(title: "Center", image: "text.aligncenter") { executeCommand("JustifyCenter") },
                            LabelButton(title: "Right", image: "text.alignright") { executeCommand("JustifyRight") },
                            LabelButton(title: "Justify", image: "text.justify") { executeCommand("JustifyFull") }
                        ]])
                        
                        CustomMenu(title: "List", icon: "list.bullet", type: .large, submenus: [[
                            LabelButton(title: "Numbered List", image: "list.number") {},
                            LabelButton(title: "Bullet List", image: "list.bullet") {}
                        ]])
                        
                        Button {
                            setLineSpacing.toggle()
                        } label: {
                            Image(systemName: "arrow.up.and.down.text.horizontal")
                        }
                        .popover(isPresented: $setLineSpacing) {
                            Stepper("Line Spacing: \(String(format: "%.1f", lineSpacing))", value: $lineSpacing, step: 0.5)
                                .padding(20)
                        }
                                                
                        CustomMenu(title: "Indentation", icon: "increase.indent", type: .small, submenus: [[
                            LabelButton(title: "Increase Indent", image: "increase.indent") { executeCommand("Indent") },
                            LabelButton(title: "Decrease Indent", image: "decrease.indent") { executeCommand("Outdent") }
                        ]])
                    }.frame(width: 325)
                    
                    
                }
            }
            
            ToolbarItemGroup(placement: ToolbarItemPlacement.primaryAction) {
               
                ShareLink(item: URL(string: "https://www.google.com")!)

                Menu {
                    LabelButton(title: "Customize Toolbar", image: "wrench.adjustable") {
                        
                    }
                } label: { Label("Settings", systemImage: "ellipsis.circle") }
            }
        }
        .toolbarRole(.editor)
        .navigationTitle("TEST")
        .navigationSplitViewStyle(.prominentDetail)
    }
    
    func executeCommand(_ command: String, args: AnyObject...) {
        let jsScript = "tinymce.activeEditor.execCommand(\"\(command)\");"
        webView.evaluateJavaScript(jsScript) { (result, error) in
            if error != nil {
                print("ERROR: \(error?.localizedDescription)")
            }
        }
    }
        
}

struct WordPadView_Previews: PreviewProvider {
    
    static var wp: WordPad {
        let wp = WordPad()
        wp.title = "test"
        wp.folder = Folder(title: "folder test", parentFolder: nil, documents: [Document](), subFolders: nil)
        wp.date = Date.now
        wp.addToStoredPages(Page(text: "New Page", index: 0))
        return wp
    }
    
    
    
    static var previews: some View {
        NavigationStack {
            WordPadView(wordPad: wp)
        }
        .environmentObject(MasterDirectory())
        .environmentObject(UpdateView())

    }
}
