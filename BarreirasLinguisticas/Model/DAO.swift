//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class DAO: ObservableObject {
    //static var unicaInstancia = DAO()
    @Published var salas: [Sala] = []
    @Published var usuarios: [Usuario] = []
    
    init(){
        self.usuarios.append(Usuario(id: 1, email: "matheus@boladao.com", senha: "sucoDeAbacaxi", nome: "Matheus Moreira", foto_perfil: "foto_matheus", pais: "USA", fluencia_ingles: "Intermediate"))
        self.usuarios.append(Usuario(id: 2, email: "victor@boladao.com", senha: "niteroiAmorzinho", nome: "Victor Duarte", foto_perfil: "foto_victor", pais: "Spain", fluencia_ingles: "Advanced"))
        self.usuarios.append(Usuario(id: 3, email: "evelyn@boladona.com", senha: "roxoComAmarelo", nome: "Evelyn de Jesus", foto_perfil: "foto_evelyn", pais: "Brazil", fluencia_ingles: "Basic"))
        self.usuarios.append(Usuario(id: 4, email: "leonardo@boladao.com", senha: "monalisa", nome: "Leonardo da Vinci", foto_perfil: "foto_leo", pais: "Italy", fluencia_ingles: "Zero"))
        self.usuarios.append(Usuario(id: 5, email: "michelle@boladona.com", senha: "democracia", nome: "Michelle Obama", foto_perfil: "foto_michelle", pais: "USA", fluencia_ingles: "Advanced"))
    }
    
    func getSala(id: Int) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
    
    func getUsuario(id: Int) -> Usuario? {
        for user in self.usuarios {
            if (id == user.id) { return user }
        }
        return nil
    }
    
    func addNovaSala(_ sala: Sala){
        self.salas.append(sala)
    }
    
    func addNovoUsuario(_ usuario: Usuario){
        self.usuarios.append(usuario)
    }
}
