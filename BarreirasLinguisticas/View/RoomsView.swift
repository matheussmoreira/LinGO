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
    @ObservedObject var usuario: Usuario
    var salas: [Sala] { return dao.getSalasByUser(id: usuario.id) }
    
    var body: some View {
        VStack{
            if salas.count == 0 {//usuario.salas.count == 0 {
                Text("\(usuario.nome)'s Rooms")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("There are no rooms :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else{
                NavigationView {
                    VStack{
                        Text("\(usuario.nome)'s Rooms")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Choose a Room")
                            .font(.title)
                        ForEach(/*usuario.*/salas) { sala in
                            NavigationLink(destination: ContentView(sala: sala, usuario: self.usuario)){
                                Text("Go to \(sala.nome)")
                            }
                        }
                        Spacer()
                    } //VStack
                } //NavigationView
            } //else
            Button(action: {self.novaSala(nome: "Room \(self.dao.salas.count+1)", criador: self.usuario)}) {
                Text("Add new Room")
            }
        } //VStack
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
        RoomsView(usuario: DAO().usuarios[0]).environmentObject(DAO())
    }
}
