//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

var dao = DAO() //na main do sistema

class DAO: ObservableObject {
    @Published var salas: [Sala] = []
    @Published var usuarios: [Usuario] = []
    @Published var sala_atual: Sala? //mover para Usuario
    @Published var usuario_atual: Usuario?
    
    fileprivate init(){
        //Sala.loadAll
        //Usuario.loadAll
    }
    
    func getSala(id: Int) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
    
    func getSalasByUser(id: Int) -> [Sala] {
        var salas: [Sala] = []
        for sala in self.salas {
            for membro in sala.membros {
                if (id == membro.usuario.id) { salas.append(sala) } 
            }
        }
        return salas
    }
    
    func getSalasWithoutUser(id: Int) -> [Sala] {
        var salasWithout: [Sala] = []
        for sala in salasWithout {
            for membro in sala.membros {
                if (membro == sala.membros.last! && membro.usuario.id != id) {
                    salasWithout.append(sala)
                }
            }
        }
        return salasWithout
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
    
    func removeSala(_ sala: Sala) {
        salas.removeAll(where: {$0.id == sala.id})
    }
}
