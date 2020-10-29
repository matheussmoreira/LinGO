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
    @Binding var enterMode: EnterMode
    @State private var showAlertLogOut = false
    @State private var showRooms = false
    @State private var showProfile = false
    var sala_atual: Sala? { return dao.sala_atual }
    var usuario: Usuario { return dao.usuario_atual! }
    var membro: Membro? {
        if sala_atual != nil {
            return sala_atual!.getMembro(id: usuario.id)!
        }
        return nil
    }
    
    var body: some View {
        VStack {
            if sala_atual != nil {
                TabView() {
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
                    ProfileView(enterMode: $enterMode)
                        .environmentObject(membro!)
                        .environmentObject(sala_atual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "person")
                            Text("You")
                        }
                }
            }
            else {
                EmptyRoom(
                    usuario: usuario,
                    showRooms: $showRooms,
                    showProfile: $showProfile,
                    showAlertLogOut: $showAlertLogOut,
                    enterMode: $enterMode
                )
                .environmentObject(dao)
                .transition(.opacity)
                .animation(.easeOut)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    } //body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(enterMode: .constant(.none))
    }
}

struct EmptyRoom: View {
    @EnvironmentObject var dao: DAO
    @ObservedObject var usuario: Usuario
    @Binding var showRooms: Bool
    @Binding var showProfile: Bool
    @Binding var showAlertLogOut: Bool
    @Binding var enterMode: EnterMode
    
    var body: some View {
        ZStack {
            Color("lingoBlueBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("You don't belong to any room yet 😕\nCreate a new one or accept an invitation!")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Button(action: {
                    self.showRooms.toggle()
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 300.0, height: 50.0)
                            .foregroundColor(.white)
                        
                        Text("Rooms")
                    }
                    
                }
                .sheet(isPresented: $showRooms) {
                    RoomsView(usuario: self.usuario)
                        .environmentObject(self.dao)
                }
                
                Button(action: {
                    self.showProfile.toggle()
                    
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 300.0, height: 50.0)
                            .foregroundColor(.white)
                        Text("My Profile")
                    }
                }
                .sheet(isPresented: $showProfile) {
                    EditProfileView(usuario: self.usuario)
                }
                
                Button(action: {
                    self.showAlertLogOut.toggle()
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 300.0, height: 50.0)
                            .foregroundColor(.white)
                        Text("Log Out")
                    }
                }
                .alert(isPresented: $showAlertLogOut) {
                    Alert(title: Text("Are you sure you want to log out?"),
                          primaryButton: .default(Text("Log out")) {
                            self.enterMode = .none
                          },
                          secondaryButton: .cancel()
                    )
                }
            }
        }
    } //body
}
