//
//  WelcomeView.swift
//  Harmony
//
//  Created by Aadi Anand on 3/28/23.
//

import SwiftUI
import StoreKit
import PSPDFKit
import PSPDFKitUI

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {        
            Text("Welcome!")
                .fontWeight(.heavy)
                .font(.largeTitle)
            
            Spacer()
            
            Image("Icon")
                .resizable()
                .frame(minWidth: 100, maxWidth: 300, minHeight: 100, maxHeight: 300)
            
            Spacer()
            
            Text("What Plan would you like to use?")
                .fontWeight(.regular)
                .font(.title2)
                .padding(.bottom, 30)
            
            Button {
                Task {
                    do {
                        let premium = try await Product.products(for: ["com.harmony.premium"]).first
                        try await premium?.purchase()
                        // Making a purchase without listening for transaction updates risks missing successful purchases. Create a Task to iterate Transaction.updates at launch.
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            } label: {
                Text("Purchase unlimited storage for $0.99/mo")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(20)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 7.5))
            
            
            Button {
                dismiss()
            } label: {
                Text("Free trial with only 1 GB of storage")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(20)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 7.5))
            

        }
        .padding([.top, .bottom], 30)
        .padding([.leading, .trailing], 20)
        .onAppear {
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            AppDelegate.orientationLock = .all
        }
    }
    

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
            .sheet(isPresented: .constant(true)) { WelcomeView() }
    }
}
