//
//  EnterView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 27/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct EnterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var enterMode: EnterMode
    var body: some View {
        VStack{
            //TRACINHO DO SHEET
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top,10)
            Spacer()
            Text("What do you want to do?")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            Button(action: {
//                let defaults = UserDefaults.standard
//                let retrievedId = defaults.integer(forKey: "UserId")
//
//                if retrievedId != 0 {
//                    self.presentationMode.wrappedValue.dismiss()
//                    enterMode = .logIn
//                }
                    
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    
                    Text("Log-in")
                        .foregroundColor(.white)
                }
            }
            
            Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    enterMode = .signUp
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    
                    Text("Create a new account")
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        
    }
}

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView(enterMode: .constant(.none))
    }
}
