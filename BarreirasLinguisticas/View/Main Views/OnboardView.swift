//
//  WelcomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD

struct OnboardView: View {
    @EnvironmentObject var dao: DAO
    @State private var getStarted = false
    @State private var loading = false
    @Binding var logInStatus: LogInSystem
    var onboardPages = Onboard.getAll
    
    var body: some View {
        
        VStack {
            // FIGURINHAS
            TabView{
                ForEach(0..<onboardPages.count){ idx in
                    VStack{
                        Image(onboardPages[idx].image)
                            .resizable()
                            .scaledToFit()
                        VStack{
                            Text(onboardPages[idx].heading)
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                                .layoutPriority(1)
                                .multilineTextAlignment(.center)
                            
                            Text(onboardPages[idx].subheading)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            // BOTAO GET STARTED
            if !loading {
                Button(action: {
                    self.loading = true
                    logInStatus = .loggedIn
                    UserDefaults.standard.set(
                        logInStatus.rawValue,
                        forKey: "LastEnterMode"
                    )
                    //carregaUsuario()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250.0, height: 40.0)
                            .foregroundColor(.black)
                        
                        Text("Enter with Apple ID")
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical)
            } else {
                ProgressView("")
            }
        } // VStack
        .background(
            Color("lingoBlueBackground")
                .edgesIgnoringSafeArea(.all)
        )
        
    }//body
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(logInStatus: .constant(.loggedOut))
    }
}
