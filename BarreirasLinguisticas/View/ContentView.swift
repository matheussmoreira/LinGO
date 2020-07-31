//
//  ContentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sala: Sala
    @ObservedObject var usuario: Usuario
    var membro: Membro { return sala.getMembro(id: usuario.id)!}
    //@State private var selection = 2
    
    var body: some View {
        TabView(/*selection: $selection*/) {
            CategoriesView(sala: sala, membro: membro).tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            HomeView(sala: sala, membro: membro).tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            PublicationView(sala: sala, membro: membro).tabItem{
                Image(systemName: "command")
                Text("Publish")
            }
            ProfileView(sala: sala, membro: membro).tabItem{
                Image(systemName: "command")
                Text("Profile")
            }
        } //TabView
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sala: DAO().salas[0], usuario: DAO().usuarios[0])/*.environmentObject(DAO())*/
    }
}
