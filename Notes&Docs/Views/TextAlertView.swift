//
//  TextAlertView.swift
//  Notes&Docs
//
//  Created by Aadi Anand on 1/20/22.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
}

struct TextAlertView: View {
    @EnvironmentObject var directory: Folder
    @State var cancelHandler: () throws -> Void
    @State var successHandler: () throws -> Void
    @State private var buttonClicked = false
    @State var itemType: Item.Type
    @ObservedObject var textAlert: TextAlert
    
    init(alert textAlert: TextAlert, itemType: Item.Type, cancelHandler: @escaping (() throws -> Void) = {}, successHandler: @escaping (() throws -> Void) = {}) {
        self.textAlert = textAlert
        self.itemType = itemType
        self.cancelHandler = cancelHandler
        self.successHandler = successHandler
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.clear)
                .background(.thickMaterial)
                .scaledToFill()
            HStack {
                VStack {
                    Text(textAlert.title)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Divider()
                    
                    HStack {
                        TextField("", text: $textAlert.text)
                            .font(.system(size: 15))
                            .padding(10)
                            
                    }
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding([.top, .bottom], 5)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            do {
                                try cancelHandler()
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .hoverEffect(.automatic)
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        Button {
                            buttonClicked.toggle()
                            
                            if !textAlert.text.isEmpty {
                                buttonClicked = false
                                do {
                                    try successHandler()
                                } catch {
                                    fatalError(error.localizedDescription)
                                }
                                textAlert.text = ""
                            }
                        } label: {
                            Text("OK")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .hoverEffect(.automatic)
                            
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .frame(height: 40)
                }
            }
            .padding()

        }
        .frame(maxWidth: 320, maxHeight: 190, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .opacity(textAlert.visibility ? 1 : 0)
        .modifier(ShakeEffect(shakes: (textAlert.text.isEmpty && buttonClicked) ?  2 : 0))
        .animation(.linear(duration: 0.5), value: buttonClicked)
    }
}

struct TextAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TextAlertView(alert: TextAlert(title: "Alert Title"), itemType: Item.self)
            .previewInterfaceOrientation(.landscapeLeft)
//            .environment(\.colorScheme, .dark)
    }
}
