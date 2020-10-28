//
//  RoomsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @State private var showAvailableRooms = false
    @State private var myRooms_selected = true
    @State private var searchRooms_selected = false
    @State private var myRoomsColor = Color.primary
    @State private var searchRoomsColor = Color.blue
    
    var usuario: Usuario
    var salas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color("lingoBlueBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("lingoLogoWhite")
                        .padding()
                        .frame(width: 300, height: 200)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clear)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: UIScreen.width-20, height: 40)
                        
                        HStack {
                            HStack {
                                Button(action: {
                                    switchScreen(state: self.myRooms_selected)
                                }) {
                                    Text("My Rooms")
                                        .font(.subheadline)
                                        .foregroundColor(myRoomsColor)
                                }
                            }
                            .padding(.horizontal, 32)
                            
                            Divider()
                                .frame(height: 40)
                            
                            HStack {
                                Button(action: {
                                    switchScreen(state: self.searchRooms_selected)
                                }) {
                                    Text("Search Rooms")
                                        .font(.subheadline)
                                        .foregroundColor(searchRoomsColor)
                                }
                            }
                            .padding(.horizontal, 32)
                            
                        }
                    }
                    
                    if myRooms_selected {
                        SelectRoomsView(usuario: usuario)
                            .environmentObject(dao)
                            .padding(.top)
                    } else {
                        AvailableRoomsView(usuario: usuario)
                            .environmentObject(dao)
                            .padding(.top)
                    }
                }
                
            }
        }
    } //body
    
    func switchScreen(state isOn: Bool) {
        if !isOn {
            myRooms_selected.toggle()
            searchRooms_selected.toggle()
            if myRooms_selected {
                myRoomsColor = Color.primary
                searchRoomsColor = LingoColors.lingoBlue
            }
            else {
                myRoomsColor = LingoColors.lingoBlue
                searchRoomsColor = Color.primary
            }
        }
    }
    
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(usuario: DAO().usuarios[2])
    }
}

struct SelectRoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
//    @State private var showAvailableRooms = false
    var usuario: Usuario
    var minhasSalas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack {
            Text("Select a room or create a new one!")
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            if !minhasSalas.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(minhasSalas) { sala in
                        ZStack {
                            Capsule()
                                .frame(width: 300.0, height: 50.0)
                                .foregroundColor(.white)
                            
                            Button(action: { self.presentationMode.wrappedValue.dismiss()
                                self.dao.sala_atual = sala
                            }) {
                                Text(sala.nome)
                                    .foregroundColor(LingoColors.lingoBlue)
                            }
                        }
                    }
                }
            } else {
                Spacer()
                Text("You don't belong\nto any room yet :(")
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // BOTAO DE ADD NEW ROOM
            Button(action: {
                self.novaSala(
                    nome: "Room \(self.dao.salas.count+1)",
                    criador: self.usuario)
            }) {
                ZStack {
                    Capsule()
                        .frame(width: 150.0, height: 50.0)
                        .foregroundColor(.green)
                    HStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.white)
                        Text("New Room")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            
        }
    }
    
    func novaSala(nome: String, criador: Usuario) {
        let sala = Sala(
            id: UUID().hashValue,
            nome: nome,
            criador: criador
        )
        self.dao.addNovaSala(sala)
    }
}

struct AvailableRoomsView: View {
    @EnvironmentObject var dao: DAO
    var usuario: Usuario
    var salasDisponiveis: [Sala] {
        return dao.getSalasWithoutUser(id: usuario.id)
    }
    
    var body: some View {
        VStack{
            Text("Which room are you looking for?")
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            if !salasDisponiveis.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(salasDisponiveis) { sala in
                        ZStack {
                            Capsule()
                                .frame(width: 300.0, height: 50.0)
                                .foregroundColor(.white)
                            
                            Button(action: {
//                                self.dao.sala_atual = sala
                            }) {
                                Text(sala.nome)
                                    .foregroundColor(LingoColors.lingoBlue)
                            }
                        }
                    }
                }
                
            } else {
                Spacer()
                Text("No available rooms :(")
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
        }
    }
    
}
