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
    @EnvironmentObject var directory: Directory
    @State var cancelHandler: () -> Void
    @State var successHandler: () -> Void
    @State private var buttonClicked = false
    
    @Binding var textInput: String
    @State var textAlert: TextAlert
    
    init(alert textAlert: TextAlert, text textInput: Binding<String>, cancelHandler: @escaping (() -> Void) = {}, successHandler: @escaping (() -> Void) = {}) {
        self.textAlert = textAlert
        self._textInput = textInput
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
                        TextField("", text: $textInput)
                            .font(.system(size: 15))
                            .padding(10)
                            
                    }
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding([.top, .bottom], 5)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            cancelHandler()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .hoverEffect(.automatic)
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        Button {
                            buttonClicked.toggle()
                            
                            if !textInput.isEmpty {
                                buttonClicked = false
                                successHandler()
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
        .modifier(ShakeEffect(shakes: (textInput.isEmpty && buttonClicked) ?  2 : 0))
        .animation(.linear(duration: 0.5), value: buttonClicked)
    }
}

struct TextAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TextAlertView(alert: TextAlert(title: "Alert Title"), text: .constant("Alert Text"))
            .previewInterfaceOrientation(.landscapeLeft)
//            .environment(\.colorScheme, .dark)
    }
}
