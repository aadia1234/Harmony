//
//  DocumentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


struct FileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var renameAlert: TextAlert
    @ObservedObject var doc: Document
    @EnvironmentObject var master: MasterDirectory
    @Environment(\.editMode) var editMode
    @State private var viewSelected = false
    @State private var presentView = false
    @Binding private var selection: Set<Document>
    @State private var thumbnail: Image = Image(systemName: "pencil")
    
    init(_ doc: Document, _ selection: Binding<Set<Document>>) {
        self.doc = doc
        self._selection = selection
    }

    var body: some View {
        ZStack {
            Button {
                viewSelected.toggle()
                if editMode?.wrappedValue == .inactive {
                    presentView.toggle()
                } else if editMode?.wrappedValue == .active {
                    if selection.contains(doc) {
                        selection.remove(doc)
                    } else {
                        selection.update(with: doc)
                    }
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
                            .foregroundColor((viewSelected && editMode?.wrappedValue == .active) ? .accentColor : .clear)
                            .frame(width: 20.0, height: 20.0)
                            .overlay {
                                ZStack {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 10, height: 10, alignment: .center)
                                        .opacity((viewSelected && editMode?.wrappedValue == .active) ? 1 : 0)
                                        .foregroundColor(.white)
                                    Circle()
                                        .stroke((viewSelected && editMode?.wrappedValue == .active) ? .white : .gray, lineWidth: 2)
                                 }
                                
                            }
                            .position(x: 126, y: 180)
                            .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                            
                    }
                    .overlay {
                        if editMode?.wrappedValue == .active {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentColor, lineWidth: (viewSelected && editMode?.wrappedValue == .active) ? 2 : 0)
                        }
                    }
                    
                    Spacer()
                    
                    Text(doc.title)
                    Text(doc.lastOpened, format: .dateTime.day().month().year())
                        .font(.footnote)
                    Spacer()
                }
                .contextMenu {
                    Button {
                        // rename document
                        
                    } label: {
                        Label("Rename", systemImage: "character.cursor.ibeam")
                    }
                    Button {
                        // move document
                    } label: {
                        Label("Move", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    Button(role: .destructive) {
                        doc.delete()
                    } label: {
                        Label("Delete Document", systemImage: "trash")
                    }
                }
                

            }
            
            NavigationLink(isActive: $presentView) {
                if doc is Note {
                    NoteView(note: doc as! Note)
                } else if doc is WordPad {
                    WordPadView(wordPad: doc as! WordPad)
                }
            } label: {
                EmptyView()
            }
        }
        .onAppear {
            if let data = doc.thumbnailData { thumbnail = Image(uiImage: UIImage(data: data)!)}
        }
        .onChange(of: editMode?.wrappedValue == .inactive) { _ in
            selection.removeAll()
            viewSelected = false
        }
        .frame(width: 250, height: 250, alignment: .center)
        .padding()
    }
}

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView(Note(), .constant([Document()]))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(MasterDirectory())
    }
}
