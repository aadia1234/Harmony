//
//  DocumentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


struct FileView: View {
    @EnvironmentObject var itemAlert: TextAlert
    @EnvironmentObject var master: MasterDirectory
    
    @ObservedObject var doc: Document
    @Binding private var selection: Set<Document>
    @Binding private var isEditing: Bool
    @State private var viewSelected = false
    @State private var presentView = false
    @State private var thumbnail: UIImage
    
    func thumbnailIsSystemImage() -> Bool {
        return thumbnail.pngData() == UIImage(systemName: "doc.plaintext.fill")?.pngData() || thumbnail.pngData() == UIImage(systemName: "pencil")?.pngData()
    }
    
    var thumbnailImage: Image {
        if thumbnailIsSystemImage() {
            return Image(systemName: (doc is WordPad) ? "doc.plaintext.fill" : "pencil")
        } else {
            return Image(uiImage: UIImage(data: doc.thumbnailData!)!)
        }
    }
    
    init(_ doc: Document, _ selection: Binding<Set<Document>>, _ isEditing: Binding<Bool>) {
        self.doc = doc
        self._selection = selection
        self._thumbnail = State(initialValue: UIImage(systemName: (doc is WordPad) ? "doc.plaintext.fill" : "pencil")!)
        self._isEditing = isEditing
    }
    
    var fileLabel: some View {
        VStack {
            ZStack {
                Color(uiColor: .systemGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                
                
                thumbnailImage
                    .resizable()
                //                            .scaleEffect(0.9)
                    .scaledToFit()
                    .padding(15)
                    .foregroundColor(.accentColor)
                
                Circle()
                    .size(CGSize(width: 20.0, height: 20.0))
                    .foregroundColor((viewSelected && isEditing) ? .accentColor : .clear)
                    .frame(width: 20.0, height: 20.0)
                    .overlay {
                        ZStack {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 10, height: 10, alignment: .center)
                                .opacity((viewSelected && isEditing) ? 1 : 0)
                                .foregroundColor(.white)
                            Circle()
                                .stroke((viewSelected && isEditing) ? .white : .gray, lineWidth: 2)
                        }
                    }
                    .position(x: 126, y: 180)
                    .opacity(isEditing ? 1 : 0)
                
            }
            .overlay { RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor, lineWidth: (viewSelected && isEditing) ? 2 : 0) }
            
            Spacer()
            
            Text(doc.title)
            Text(doc.date, format: .dateTime.day().month().year())
                .font(.footnote)
            Spacer()
        }
    }

    var body: some View {
        ZStack {
            if isEditing {
                Button {
                    viewSelected.toggle()
                    if !isEditing {
                        presentView.toggle()
                        print(presentView)
                    } else {
                        guard selection.contains(doc) else { selection.update(with: doc); return; }
                        selection.remove(doc)
                    }
                } label: {
                    fileLabel
                }
            } else {
                NavigationLink(value: isEditing ? nil : doc) {
                    fileLabel
                }
            }
            
        }
        .onAppear {
            if let data = doc.thumbnailData {
                thumbnail = UIImage(data: data)!
            }
        }
        .onChange(of: isEditing) { _ in selection.removeAll(); viewSelected = false }
        .frame(width: 250, height: 250, alignment: .center)
        
    }
}

//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView(Note(), .constant([Document()]))
//            .previewInterfaceOrientation(.landscapeLeft)
//            .environmentObject(MasterDirectory())
//    }
//}
