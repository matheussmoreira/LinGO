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
    @Binding var signedIn: Bool
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
                        }.padding()
                    }
                }
                
            }.tabViewStyle(PageTabViewStyle())
            
            Button(action: {self.signedIn.toggle()}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(.black)
                    
                    Text("Get started")
                        .foregroundColor(.white)
                }
            }.padding(.vertical)
        }.background(Color("lingoBlueBackground").edgesIgnoringSafeArea(.all))
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(signedIn: .constant(true))
    }
}
