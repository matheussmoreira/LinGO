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
    var body: some View {
        VStack {
            Button(action: {self.onContentView.toggle()}) {
                Text("Sign-in")
            }
        }
    }
}
