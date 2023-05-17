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
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc
        func keyboardWillChange(_ notification: NSNotification) {
            guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
            guard let startingFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let endingFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let deltaY = endingFrame.origin.y - startingFrame.origin.y
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
                self.webView.frame.origin.y += deltaY
            }, completion: nil)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        content = content
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\'", with: "\\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "")
        let jsScript = "tinymce.activeEditor.setContent(\"\(content)\");"
        webView.evaluateJavaScript(jsScript) { result, error in
            if error == nil {
                self.content = result as! String
            } else {
                fatalError(error!.localizedDescription)
            }
        }
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
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var showEditorView = false

    
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
        HStack {
            VStack {
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.bottom)
                        .ignoresSafeArea(.keyboard, edges: .bottom)


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
                                setAlert(title: "What would you like to rename \"\(wordPad.title)\" to?", type: DocumentType.self)
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
                    }
                    .toolbarRole(.automatic)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationSplitViewStyle(.prominentDetail)
                    .opacity(showEditorView ? 1 : 0)
                    .animation(.easeInOut, value: showEditorView)
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                    
                    ProgressView("Loading")
                        .tint(.accentColor)
                        .foregroundColor(.accentColor)
                        .opacity(showEditorView ? 0 : 1)
                        .onReceive(timer) { _ in
                            progress += 1
                            if progress == 10 {
                                showEditorView.toggle()
                                timer.upstream.connect().cancel()
                            }
                        }
                        .animation(.easeInOut, value: showEditorView)
                        .ignoresSafeArea(.keyboard, edges: .bottom)


                }
            }
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
            if error == nil {
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
        wp.folder = Folder(title: "folder test", parentFolder: nil, documents: [DocumentType](), subFolders: nil)
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
