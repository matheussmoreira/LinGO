//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct OnboardView: View {
    @EnvironmentObject var dao: DAO
    @State private var onContentView = false
    
    var body: some View {
        VStack {
            if !onContentView {
                IntroView(onContentView: $onContentView)
            }
            else {
                ContentView()
                    .environmentObject(dao)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                //ler depois: https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-and-remove-views-with-a-transition
            }
        } //VStack
    } //body
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}

struct IntroView: View {
    @Binding var onContentView: Bool
    @State private var introImages: [String] = ["languageSkills", "rooms", "discoverCards", "savePosts", "questions"]
    
    var body: some View {
        ZStack {
            LingoColors.lingoBlue
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(alignment: .center) {
                        ForEach(0..<self.introImages.count) { idx in
                            Image(self.introImages[idx])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.width, height: 200, alignment: .center)
                        }
                    }
                }
                
                Button(action: {self.onContentView.toggle()}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250.0, height: 40.0)
                            .foregroundColor(.black)
                            
                        Text("Sign-in with Apple")
                            .foregroundColor(.white)
                    }
                }
            }
        } //ZStack
    } //body
}
