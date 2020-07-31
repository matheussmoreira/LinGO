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
    var sala: Sala
    var usuario: Usuario
    //@State private var selection = 2
    
    var body: some View {
        TabView(/*selection: $selection*/) {
            CategoriesView(sala: sala, id_membro: usuario.id).tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            HomeView(sala: sala, id_membro: usuario.id).tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            PublicationView(sala: sala, id_membro: usuario.id).tabItem{
                Image(systemName: "command")
                Text("Publish")
            }
            ProfileView(sala: sala, id_membro: usuario.id).tabItem{
                Image(systemName: "command")
                Text("Profile")
            }
        } //TabView
        //.navigationBarBackButtonHidden(true)
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sala: DAO().salas[0], usuario: DAO().usuarios[0]).environmentObject(DAO())
    }
}
