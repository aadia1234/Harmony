//
//  DocumentView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/13/22.
//

import SwiftUI


struct FileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject var item: Item
    
    var body: some View {
        ZStack {
            NavigationLink {
                if item is Folder {
                    DirectoryView(directory: item as! Folder)
                } else if item is Note {
                    NoteView(note: item as! Note)
                } else if item is WordPad {
                    WordPadView(wordPad: item as! WordPad)
                }
            } label: {
                VStack() {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        
                        if item is Document {
                            (item as! Document).preview
                                .resizable()
                                .scaleEffect(0.90)
                        } else {
                            Image(systemName: "folder.fill")
                                .resizable()
                                .scaleEffect(0.90)
                        }
                        
                    }
                    
                    Spacer()
                    
                    Text(item.title)
                    if item is Document {
                        Text((item as! Document).lastOpened, format: .dateTime.day().month().year())
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 250, height: 250, alignment: .center)
        .padding()
    }
}

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView(item: Note())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
