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
    var usuario: Usuario
    var salas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack {
            ZStack {
                LingoColors.lingoBlue
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("lingologo")
                        .resizable()
                        .padding(.all, 32)
                        .frame(width: 300, height: 128)
                    
                    Text("Welcome back, \(usuario.nome)!")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.bottom, 50)
                    
                    
                    Text("Select a room or create a new one!")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                    
                    if salas.count != 0 {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(salas) { sala in
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
                        } //ScrollView
                    } //else
                    
                    Spacer()
                    
                    Button(action: { self.novaSala(nome: "Room \(self.dao.salas.count+1)", criador: self.usuario)}) {
                        ZStack {
                            Capsule()
                                .frame(width: 300.0, height: 50.0)
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
                    
                    Divider()
                    
                    ZStack {
                        Capsule()
                            .frame(width: 200.0, height: 50.0)
                            .foregroundColor((Color(UIColor.systemGray5)))
                        
                        Text("Logout")
                            .foregroundColor(.red)
                        
                    }
                    .padding()
                } //VStack
            }//ZStack
        } //VStack
    } //body
    
    func novaSala(nome: String, criador: Usuario) {
        let sala: Sala

        if let ultima_sala = self.dao.salas.last {
            sala = Sala(id: ultima_sala.id + 1, nome: nome, criador: criador)
        }
        else {
            sala = Sala(id: 1, nome: "Apple Developer Academy", criador: criador)
        }
        
        self.dao.addNovaSala(sala)
    }
    
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(usuario: DAO().usuarios[2])
    }
}
