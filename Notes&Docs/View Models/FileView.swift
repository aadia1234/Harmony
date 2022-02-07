//
//  DocumentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


struct FileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject var doc: Document
    @EnvironmentObject var master: MasterDirectory
    @Environment(\.editMode) var editMode
    @State private var viewClicked = false
    @State private var presentView = false
    @Binding private var selection: [Document]
    
    init(_ doc: Document, _ selection: Binding<[Document]>) {
        self.doc = doc
        self._selection = selection
    }

    var body: some View {
        ZStack {
            Button {
                viewClicked.toggle()
                if editMode?.wrappedValue == .inactive {
                    presentView.toggle()
                } else if editMode?.wrappedValue == .active && viewClicked {
                    selection.append(doc)
                }
            } label: {
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        
                        doc.preview
                            .resizable()
                            .scaleEffect(0.90)
                        
                        Circle()
                            .size(CGSize(width: 20.0, height: 20.0))
                            .foregroundColor((viewClicked && editMode?.wrappedValue == .active) ? .accentColor : .clear)
                            .frame(width: 20.0, height: 20.0)
                            .overlay {
                                ZStack {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .frame(width: 10, height: 10, alignment: .center)
                                        .opacity((viewClicked && editMode?.wrappedValue == .active) ? 1 : 0)
                                        .foregroundColor(.white)
                                    Circle()
                                        .stroke((viewClicked && editMode?.wrappedValue == .active) ? .white : .gray, lineWidth: 2)
                                }
                                
                            }
                            .position(x: 126, y: 180)
                            .opacity(editMode?.wrappedValue == .active ? 1 : 0)
                            
                    }
                    .overlay {
                        if editMode?.wrappedValue == .active {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accentColor, lineWidth: (viewClicked && editMode?.wrappedValue == .active) ? 2 : 0)
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            master.cd.documents.removeAll(where: {$0.id == doc.id })
                        } label: {
                            Label("Delete Document", systemImage: "trash")
                        }
                    }
                    
                    
                    Spacer()
                    
                    Text(doc.title)
                    Text(doc.lastOpened, format: .dateTime.day().month().year())
                        .font(.footnote)
                    Spacer()
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
        .onChange(of: editMode?.wrappedValue == .active) { _ in
            selection.removeAll()
            viewClicked = false
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
