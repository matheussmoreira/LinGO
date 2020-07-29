//
//  ContentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dao: DAO
    //@State private var selection = 2
    
    var body: some View {
        TabView(/*selection: $selection*/) {
            CategoriesView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            HomeView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            PublicationView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Publish")
            }
            ProfileView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("My Profile")
            }
        } //TabView
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DAO())
    }
}
