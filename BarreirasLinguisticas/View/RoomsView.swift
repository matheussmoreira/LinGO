//
//  RoomsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomsView: View {
    @EnvironmentObject var dao: DAO
    var usuario: Usuario // { return dao.usuarios[2] }
    var salas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack{
            if salas.count == 0 {
                Text("\(usuario.nome)'s Rooms")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("There are no rooms :(")
                    .foregroundColor(Color.gray)
                Spacer()
                Button(action: { self.novaSala(nome: "Room \(self.dao.salas.count+1)", criador: self.usuario)}) {
                    Text("Add new Room")
                }
            }
            else{
                NavigationView {
                    VStack{
                        Text("\(usuario.nome)'s Rooms")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                        Text("Choose a Room")
                            .font(.title)
                            .foregroundColor(.gray)
                        Spacer()
                        ForEach(salas) { sala in
                            
                            RoundedRectangle(cornerRadius: 45)
                            .fill(Color.blue)
                            .frame(height: 40)
                            .frame(width: 200)
                            .overlay(
                                NavigationLink(destination: ContentView(sala: sala, usuario: self.usuario)){
                                    Text(sala.nome)
                                        .foregroundColor(.white)
                                }
                            )
                        }
                        Spacer()
                        Button(action: { self.novaSala(nome: "Room \(self.dao.salas.count+1)", criador: self.usuario)}) {
                            Text("Add new Room")
                        }
                    } //VStack
                } //NavigationView
            } //else
        } //VStack
        .onAppear {self.novaSala(nome: "Apple Dev Academy", criador: self.usuario)}
    } //body
    
    func novaSala(nome: String, criador: Usuario) {
        var id: Int = 1
        if let ultima_sala = self.dao.salas.last {
            id = ultima_sala.id + 1
        }
        let sala = Sala(id: id, nome: nome, criador: criador)
        self.dao.addNovaSala(sala)
    }
    
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView(usuario: DAO().usuarios[2]).environmentObject(DAO())
    }
}
