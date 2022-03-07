//
//  DocumentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


struct FileView: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var itemAlert: TextAlert
    @EnvironmentObject var master: MasterDirectory
    
    @ObservedObject var doc: Document
    @Binding private var selection: Set<Document>
    @State private var viewSelected = false
    @State private var presentView = false
    @State private var thumbnail: Image = Image(systemName: "pencil")
    
    private var isEditing: Bool { editMode?.wrappedValue == .active }
    
    init(_ doc: Document, _ selection: Binding<Set<Document>>) {
        self.doc = doc
        self._selection = selection
    }

    var body: some View {
        ZStack {
            Button {
                viewSelected.toggle()
                if !isEditing {
                    presentView.toggle()
                } else {
                    guard selection.contains(doc) else { selection.update(with: doc); return; }
                    selection.remove(doc)
                }
            } label: {
                VStack {
                    ZStack {
                        thumbnail
                            .resizable()
                            .scaleEffect(0.90)
                            .background(Color(uiColor: .systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        
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
            
            NavigationLink(isActive: $presentView) {
                if doc is Note {
                    NoteView(note: doc as! Note, thumbnail: $thumbnail)
                } else {
                    WordPadView(wordPad: doc as! WordPad)
                }
            } label: { EmptyView() }
        }
        .onAppear { if let data = doc.thumbnailData { thumbnail = Image(uiImage: UIImage(data: data)!) } }
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
