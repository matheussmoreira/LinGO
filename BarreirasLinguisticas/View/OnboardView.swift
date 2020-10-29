//
//  WelcomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct OnboardView: View {
    @EnvironmentObject var dao: DAO
    @State private var getStarted = false
    @Binding var userId: Int
    @Binding var enterMode: EnterMode
    var onboardPages = Onboard.getAll
    var body: some View {
        
        VStack {
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
                
            }.tabViewStyle(PageTabViewStyle())
            
            Button(action: {self.getStarted.toggle()}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(.black)
                    
                    Text("Get started")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical)
            .sheet(isPresented: $getStarted){
                NavigationView {
                    EnterView(userId: $userId, enterMode: $enterMode)
                        .environmentObject(dao)
                        .navigationBarHidden(true)
                }
            }
        }
        .background(
            Color("lingoBlueBackground")
                .edgesIgnoringSafeArea(.all)
        )
    }//body
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(userId: .constant(0), enterMode: .constant(.none))
    }
}
