//
//  ContentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var sala: Sala
    //@State private var selection = 2
    
    var body: some View {
        TabView(/*selection: $selection*/) {
            CategoriesView(sala: sala).tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            HomeView(sala: sala).tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            PublicationView(sala: sala).tabItem{
                Image(systemName: "command")
                Text("Publish")
            }
            ProfileView(sala: sala).tabItem{
                Image(systemName: "command")
                Text("Profile")
            }
        } //TabView
        //.navigationBarBackButtonHidden(true)
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sala: DAO().salas[0])
    }
}
