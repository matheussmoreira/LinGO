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
    var sala: Sala? { return dao.sala_atual }
    var usuario: Usuario { return dao.usuario_atual! }
    var membro: Membro? {
        if sala != nil {
            return sala!.getMembro(id: usuario.id)!
        }
        return nil
    }
    @State var showRooms = false
    @State var showProfile = false
    //@State var selection = 2
    
    var body: some View {
        VStack {
            if sala != nil {
                TabView(/*selection: $selection*/) {
                    CategoriesView()
                        .environmentObject(membro!)
                        .environmentObject(sala!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "circle.grid.2x2")
                            Text("Categories")
                    }
                    DiscoverView()
                        .environmentObject(membro!)
                        .environmentObject(sala!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "rectangle.on.rectangle.angled")
                            Text("Discover")
                    }
                    ProfileView()
                        .environmentObject(membro!)
                        .environmentObject(sala!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "person")
                            Text("You")
                    }
                } //TabView
            }
            else {
                VStack {
                    Text("You don't belong to any room yet :(.\nCreate a new one or accept an invitation!")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                    Button(action: { self.showRooms.toggle() }) {
                        Text("Manage rooms")
                    }.sheet(isPresented: $showRooms) {
                        RoomsView(usuario: self.usuario)
                            .environmentObject(self.dao)
                    }
                    Button(action: { self.showProfile.toggle() }) {
                        Text("Manage my profile")
                    }.sheet(isPresented: $showProfile) {
                        ManageProfile(usuario: self.usuario)
                    }
                }
                
            }
        }
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ManageProfile: View {
    @ObservedObject var usuario: Usuario
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top,10)
            
            Spacer()
            
            Image(usuario.foto_perfil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150.0, height: 150.0)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.primary, lineWidth: 8)
                    .colorInvert()
            )
            
            Text(usuario.nome)
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
            
            HStack {
                Text(usuario.fluencia_ingles.rawValue)
                    .foregroundColor(Color.gray)
                Circle()
                    .fill(usuario.cor_fluencia)
                    .frame(width: 15.0, height: 15.0)
            }
            Spacer()
        }
    }
}
