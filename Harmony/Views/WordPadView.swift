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

struct NavigationBarModifier: ViewModifier {
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.backgroundColor = .blue
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(.clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

class WebViewController: UIViewController {
    var webView: WKWebView
    let htmlFileName: String
    var content: String
    
    init?(_ webView: WKWebView, _ htmlFileName: String, _ content: String) {
        self.webView = webView
        self.htmlFileName = htmlFileName
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView.isOpaque = false
        view = webView
    }
    
    override func viewDidLoad() {
        guard let url = Bundle.main.url(forResource: htmlFileName, withExtension: "html") else {
            return print("URL Error")
        }
        
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = false
        
        webView.loadFileURL(url, allowingReadAccessTo: url)
        webView.backgroundColor = UIColor(red: 237 / 255, green: 238 / 255, blue: 243 / 255, alpha: 1.0)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        let jsScript = "tinymce.activeEditor.getContent({ format: \"html\" });"
        webView.evaluateJavaScript(jsScript) { result, error in
            if error == nil {
                self.content = result as! String
            }
        }
    }
}

struct WebViewUI: UIViewControllerRepresentable {
    @State public var webView: WKWebView
    @State public var htmlFileName: String
    @Binding public var content: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
        
    func makeUIViewController(context: Context) -> WebViewController {
        let controller = WebViewController(webView, htmlFileName, content)!
        controller.webView.navigationDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ webViewController: WebViewController, context: Context) {
        content = webViewController.content
    }
    
    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewUI
        
        init(_ webViewController: WebViewUI) {
            parent = webViewController
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.content = parent.content
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\'", with: "\\\'")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "")
            let jsScript = "tinymce.activeEditor.setContent(\"\(parent.content)\");"
            webView.evaluateJavaScript(jsScript) { result, error in
                if error == nil {
                    self.parent.content = result as! String
                } else {
                    fatalError(error.debugDescription)
                }
            }
        }
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
    
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
}



struct WordPadView: View {
    @ObservedObject var wordPad: WordPad
    @State private var titleText = ""
    @State private var showFileNavView = false
    @EnvironmentObject var updateView: UpdateView
    @EnvironmentObject var newItemAlert: TextAlert
    @EnvironmentObject var master: MasterDirectory
    @EnvironmentObject var editorData: EditorDataModel
    
    @State private var doc: Set<WordPad> = []
    @State private var webView = WKWebView()
    
    @State private var showLinkView = false
    
    @Environment(\.dismiss) var dismiss

    @State private var setLineSpacing = false
    @State private var lineSpacing = 1.0
    
    init(wordPad: WordPad) {
        self.wordPad = wordPad
        setContent()
    }
    
    func setAlert(title: String, type: Item.Type) {
        newItemAlert.title = title
        newItemAlert.itemType = type
    }
    
    func setContent() {
        
    }
    
    var body: some View {
        ZStack {
            WebViewUI(webView: webView, htmlFileName: "editor", content: $wordPad.content)
            .sheet(isPresented: $showFileNavView) { FileNavigationView(items: $doc) }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle(wordPad.title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateView.enableSidebar = false
                updateView.update()
                updateView.changeNavigationBarAppearance()
            }
            .onDisappear {
                wordPad.date = Date.now
                DataController.shared.save()
            }
            .toolbar {
                ToolbarTitleMenu {
                    LabelButton(title: "Rename", image: "character.cursor.ibeam") {
                        master.doc = wordPad
                        setAlert(title: "What would you like to rename \"\(wordPad.title)\" to?", type: Document.self)
                    }
                    LabelButton(title: "Move", image: "rectangle.portrait.and.arrow.right") {
                        doc = [wordPad]
                        showFileNavView = true
                        master.doc = wordPad
                    }
                    LabelButton(title: "Delete", image: "trash", role: .destructive) {
                        wordPad.delete()
                        dismiss()
                    }
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
                                    LabelButton(title: "Insert Link", image: "link") {
//                                        updateView.editorAlert
                                        updateView.showEditorAlert.toggle()
                                        executeCommand("CreateLink", false, "\"\(editorData.url)\"")
                                    },
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
                                LabelButton(title: "Numbered List", image: "list.number") {
                                    let json: [String: Any] =
                                                [
                                                  "list-style-type": "decimal",
                                                  "list-item-attributes'": ["class": "mylistitemclass"],
                                                  "list-attributes": ["id": "mylist"]
                                                ]
                                    executeCommand("InsertOrderedList", false, jsonString(json)!)
                                },
                                LabelButton(title: "Bullet List", image: "list.bullet") {
                                    let json: [String: Any] =
                                                [
                                                  "list-style-type": "disc",
                                                  "list-item-attributes'": ["class": "mylistitemclass"],
                                                  "list-attributes": ["id": "mylist"]
                                                ]
                                    executeCommand("InsertOrderedList", false, jsonString(json)!)
                                }
                            ]])

                            Button {
                                setLineSpacing.toggle()
                            } label: {
                                Image(systemName: "arrow.up.and.down.text.horizontal")
                            }
                            .popover(isPresented: $setLineSpacing) {
                                Stepper("Line Spacing: \(String(format: "%.1f", lineSpacing))", value: $lineSpacing, step: 0.1)
                                    .padding(20)
                            }
                            .onChange(of: lineSpacing) { newLineHeight in
                                executeCommand("LineHeight", false, "\"\(newLineHeight)\"")
                            }

                            CustomMenu(title: "Indentation", icon: "increase.indent", type: .small, submenus: [[
                                LabelButton(title: "Increase Indent", image: "increase.indent") { executeCommand("Indent") },
                                LabelButton(title: "Decrease Indent", image: "decrease.indent") { executeCommand("Outdent") }
                            ]])
                        }
                        .frame(width: 325)
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationSplitViewStyle(.prominentDetail)
        }
        
        
        
    }
    
    func executeCommand(_ command: String, _ args: Any...) {
        var jsScript = "tinymce.activeEditor.execCommand(\"\(command)\""
        if !args.isEmpty {
            for arg in args {
                jsScript += ", \(arg)"
            }
        }
        jsScript += ");"
        webView.evaluateJavaScript(jsScript) { desc, error in
            if let error = error {
                fatalError(jsScript)
            } else {
                print(jsScript)
            }
        }
    }
    
    func jsonString(_ json: Dictionary<String, Any>) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            return String(data: data, encoding: String.Encoding.utf8)!
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct WordPadView_Previews: PreviewProvider {
    @State private static var testColor = Color.red

    static var wp: WordPad {
        let wp = WordPad()
        wp.title = "test"
        wp.folder = Folder(title: "folder test", parentFolder: nil, documents: [Document](), subFolders: nil)
        wp.date = Date.now
        return wp
    }
    
    
    static var previews: some View {
        
        NavigationStack {
            WordPadView(wordPad: wp)
        }
        .environmentObject(MasterDirectory())
        .environmentObject(UpdateView())
        .environmentObject(TextAlert(title: ""))

    }
}


extension View {
 
    func navigationBarColor() -> some View {
        self.modifier(NavigationBarModifier())
    }

}
