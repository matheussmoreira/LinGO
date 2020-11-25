//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

var dao = DAO()

class DAO: ObservableObject {
    @Published var salas: [Sala] = []
//    @Published var usuarios: [Usuario] = []
    @Published var usuarioAtual: Usuario?
    @Published var idSalaAtual: String?
    
    fileprivate init(){
        carregaSalasFromCloud()
    }
    
    func carregaSalasFromCloud(){
        CKManager.loadRecordsDasSalas { (result) in
            switch result {
                case .success(let records):
                    DispatchQueue.main.async {
                        for record in records {
                            if let sala = CKManager.getSalaFromRecord(record) {
                                self.salas.append(sala)
                            }
                        }
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func getSala(id: String) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
    
    func getSalasByUser(id: String?) -> [Sala] {
        var salas: [Sala] = []
        for sala in self.salas {
            for membro in sala.membros {
                if (id == membro.usuario.id) { salas.append(sala) } 
            }
        }
        return salas
    }
    
    func getSalasWithoutUser(id: String?) -> [Sala] {
        var salasWithout = salas
        for sala in salas {
            for membro in sala.membros {
                if (membro.usuario.id == id) {
                    salasWithout.removeAll(where: {$0.id == sala.id})
                    break
                }
            }
        }
        return salasWithout
    }
    
    func addNovaSala(_ sala: Sala){
        self.salas.append(sala)
    }
    
    func editaPublicadores(usuario: Usuario){
        for sala in salas {
            for post in sala.posts {
                if post.publicador.usuario.id == usuario.id{
                    post.publicador.usuario = usuario
                }
            }
        }
    }
    
    func removeSala(_ sala: Sala) {
        salas.removeAll(where: {$0.id == sala.id})
    }
}
