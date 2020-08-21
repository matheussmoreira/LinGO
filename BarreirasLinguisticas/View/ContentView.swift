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
    @Binding var loggedIn: Bool
    @State private var showAlertLogOut = false
    var sala_atual: Sala? { return dao.sala_atual }
    var usuario: Usuario { return dao.usuario_atual! }
    var membro: Membro? {
        if sala_atual != nil {
            return sala_atual!.getMembro(id: usuario.id)!
        }
        return nil
    }
    @State var showRooms = false
    @State var showProfile = false
    //@State var selection = 2
    
    var body: some View {
        VStack {
            if sala_atual != nil {
                TabView(/*selection: $selection*/) {
                    DiscoverView()
                        .environmentObject(membro!)
                        .environmentObject(sala_atual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "rectangle.on.rectangle.angled")
                            Text("Discover")
                    }
                    CategoriesView()
                        .environmentObject(membro!)
                        .environmentObject(sala_atual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "circle.grid.2x2")
                            Text("Categories")
                    }
                    ProfileView(loggedIn: $loggedIn)
                        .environmentObject(membro!)
                        .environmentObject(sala_atual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "person")
                            Text("You")
                    }
                } //TabView
            }
            else {
                EmptyRoom(usuario: usuario, showRooms: $showRooms, showProfile: $showProfile, showAlertLogOut: $showAlertLogOut, loggedIn: $loggedIn)
            }
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(loggedIn: .constant(true))
    }
}

struct EmptyRoom: View {
    @EnvironmentObject var dao: DAO
    @ObservedObject var usuario: Usuario
    @Binding var showRooms: Bool
    @Binding var showProfile: Bool
    @Binding var showAlertLogOut: Bool
    @Binding var loggedIn: Bool
    
    var body: some View {
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
                EditProfileView(usuario: self.usuario)
            }
            Button(action: {self.showAlertLogOut.toggle()}) {
                Text("Log Out")
            }.alert(isPresented: $showAlertLogOut) {
                Alert(title: Text("Are you sure you want to log out?"),
                      primaryButton: .default(Text("Log out")) {self.loggedIn.toggle()},
                      secondaryButton: .cancel())
            }
        }
    }
}
