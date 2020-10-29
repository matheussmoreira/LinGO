//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

enum EnterMode: Int {
    case signUp = 1
    case logIn = 2
    case none = -1
}

struct FirstView: View {
    @EnvironmentObject var dao: DAO
    @State private var enterMode = EnterMode.none
    @State private var getStarted = false
    @State private var userId: Int = -1
    
    var body: some View {
        VStack {
            if userId == 0 || enterMode == .none {
                OnboardView(userId: $userId, enterMode: $enterMode)
            } else {
                ContentView(enterMode: $enterMode)
                    .environmentObject(dao)
            }
        }
        .onAppear{
            let defaults = UserDefaults.standard
            userId = defaults.integer(forKey: "UserId")
            let storedEnterMode = defaults.integer(forKey: "LastEnterMode")
            switch storedEnterMode {
                case 1:
                    enterMode = .signUp
                case 2:
                    enterMode = .logIn
                default:
                    enterMode = .none
            }
        }
    } //body
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
