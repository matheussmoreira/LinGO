//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

enum EnterMode {
    case signUp
    case logIn
    case none
}

struct FirstView: View {
    @EnvironmentObject var dao: DAO
    @State private var enterMode = EnterMode.none
    @State private var getStarted = false
    
    var body: some View {
        VStack {
            if enterMode == .none {
                OnboardView(enterMode: $enterMode)
            }
//            else if enterMode == .signUp {
//                NavigationView {
//                    NewUserView(enterMode: $enterMode)
//                        .environmentObject(dao)
//                }
//            }
            else {
                ContentView(enterMode: $enterMode)
                    .environmentObject(dao)
            }
        }
    } //body
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
