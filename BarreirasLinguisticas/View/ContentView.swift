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
    var sala: Sala { return dao.sala_atual! }
    var usuario: Usuario { return dao.usuario_atual! }
    var membro: Membro { return sala.getMembro(id: usuario.id)! }
    //@State var selection = 2
    
    var body: some View {
        //NavigationView {
            TabView(/*selection: $selection*/) {
                CategoriesView()
                    .environmentObject(membro)
                    .environmentObject(dao)
                    .tabItem {
                    Image(systemName: "circle.grid.2x2")
                    Text("Categories")
                }
                DiscoverView()
                    .environmentObject(membro).tabItem {
                    Image(systemName: "rectangle.on.rectangle.angled")
                    Text("Discover")
                }
//                PostEditorView()
//                    .environmentObject(membro).tabItem {
//                    Image(systemName: "pencil")
//                    Text("Publish")
//                }
                ProfileView()
                    .environmentObject(membro).tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        } //TabView
        //} //ContentView
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
