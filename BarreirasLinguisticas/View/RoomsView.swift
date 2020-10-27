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
                Color("lingoBlueBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("lingoLogoWhite")
                        .padding()
                        .frame(width: 300, height: 268)
                    
                    Text("Select a room or create a new one!")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.bottom, 50)
                    
                    if !salas.isEmpty {
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
                    } //if
                    
                    Spacer()
                    
                    Button(action: {
                        self.novaSala(
                            nome: "Room \(self.dao.salas.count+1)",
                            criador: self.usuario)
                    }) {
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
                } //VStack
            }//ZStack
        } //VStack
    } //body
    
    func novaSala(nome: String, criador: Usuario) {
        let sala = Sala(
            id: UUID().hashValue,
            nome: nome,
            criador: criador
        )
        self.dao.addNovaSala(sala)
        //print(dao.usuario_atual?.nome)
        //        if let ultima_sala = self.dao.salas.last {
        //            sala = Sala(id: ultima_sala.id + 1, nome: nome, criador: criador/*, dao: self.dao*/)
        //        }
        //        else {
        //            sala = Sala(id: 1, nome: "Apple Developer Academy", criador: criador/*, dao: self.dao*/)
        //        }
    }
    
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(usuario: DAO().usuarios[2])
    }
}
