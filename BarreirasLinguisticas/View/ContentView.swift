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
    @ObservedObject var sala: Sala
    @ObservedObject var usuario: Usuario
    var membro: Membro { return sala.getMembro(id: usuario.id)! }
    //@State var selection = 4
    
    var body: some View {
        NavigationView {
            TabView(/*selection: $selection*/) {
                CategoriesView(sala: sala)
                    .environmentObject(membro)
                    .environmentObject(dao)
                    .tabItem {
                    Image(systemName: "circle.grid.2x2")
                    Text("Categories")
                }
                DiscoverView(sala: sala)
                    .environmentObject(membro).tabItem {
                    Image(systemName: "rectangle.on.rectangle.angled")
                    Text("Discover")
                }
                PostEditorView(sala: sala)
                    .environmentObject(membro).tabItem {
                    Image(systemName: "pencil")
                    Text("Publish")
                }
                ProfileView(sala: sala)
                    .environmentObject(membro).tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            } //TabView
        }
        
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sala: DAO().salas[0], usuario: DAO().usuarios[0])
    }
}
