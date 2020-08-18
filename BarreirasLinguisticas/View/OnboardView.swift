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
    var body: some View {
        NavigationView {
            NavigationLink(destination: ContentView().environmentObject(dao)){
                Text("Sign-in")
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}
