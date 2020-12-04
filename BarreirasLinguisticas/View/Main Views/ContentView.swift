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
    @Binding var logInStatus: LogInSystem
    @Binding var usuarioAtual: Usuario?
    @State private var showAlertLogOut = false
    @State private var showRooms = false
    @State private var showProfile = false
    var salaAtual: Sala? {
        return dao.salaAtual
    }
    var membroAtual: Membro? {
        return dao.membroAtual
    }
    
    var body: some View {
        VStack {
            if salaAtual != nil && membroAtual != nil {
                //MARK: -  TABVIEW
                TabView() {
                    DiscoverView()
                        .environmentObject(membroAtual!)
                        .environmentObject(salaAtual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "rectangle.on.rectangle.angled")
                            Text("Discover")
                        }
                    CategoriesView()
                        .environmentObject(membroAtual!)
                        .environmentObject(salaAtual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "circle.grid.2x2")
                            Text("Categories")
                        }
                    ProfileView(logInStatus: $logInStatus)
                        .environmentObject(membroAtual!)
                        .environmentObject(salaAtual!)
                        .environmentObject(dao)
                        .tabItem {
                            Image(systemName: "person")
                            Text("You")
                        }
                }
            }
            else {
                EmptyRoom(
                    usuario: usuarioAtual!,
                    showRooms: $showRooms,
                    showProfile: $showProfile,
                    showAlertLogOut: $showAlertLogOut,
                    enterMode: $logInStatus
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(enterMode: .constant(.logOut), usuario_atual: .constant(Usuario()))
//    }
//}

struct EmptyRoom: View {
    @EnvironmentObject var dao: DAO
    @ObservedObject var usuario: Usuario
    @Binding var showRooms: Bool
    @Binding var showProfile: Bool
    @Binding var showAlertLogOut: Bool
    @Binding var enterMode: LogInSystem
    
    var body: some View {
        ZStack {
            Color("lingoBlueBackground")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text("Welcome to LinGO!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Text("You don't belong to any room yet\nLet's explore!")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
                
                //MARK: -  BOTAO ROOMS
                Button(action: {
                    self.showRooms.toggle()
                }) {
                    ZStack {
                        Capsule()
                            .frame(width: 300.0, height: 50.0)
                            .foregroundColor(.white)
                        
                        Text("Explore Rooms")
                    }
                    
                }
                .sheet(isPresented: $showRooms) {
                    RoomsView(usuario: self.usuario)
                        .environmentObject(self.dao)
                }
                
                //MARK: -  BOTAO PROFILE
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
                        .environmentObject(dao)
                }
                
                //MARK: -  BOTAO LOGOUT
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
                            self.enterMode = .loggedOut
                            UserDefaults.standard.set(
                                enterMode.rawValue,
                                forKey: "LastEnterMode"
                            )
                          },
                          secondaryButton: .cancel()
                    )
                }
                
            } // VStack
        } // ZStack
    } //body
}
