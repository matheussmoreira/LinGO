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
    @Published var usuario_atual: Usuario?
    
    fileprivate init(){
        carregaSalasFromCloud()
//        Sala.ckLoadAll { result in
//            switch result {
//                case .success(let loadedSalas):
//                    DispatchQueue.main.async {
//                        self.salas = loadedSalas as? [Sala] ?? []
//                    }
//                case .failure(let error):
//                    print("DAO init .failure")
//                    print(error)
//            }
//        }
//        Usuario.ckLoadAll { result in
//            switch result {
//                case .success(let loadedUsers):
//                    DispatchQueue.main.async {
//                        self.usuarios = loadedUsers as? [Usuario] ?? []
//                    }
//                case .failure(let error):
//                    print(error)
//            }
//        }
    }
    
    func carregaSalasFromCloud(){
        CKManager.loadSalasRecords { (result) in
            switch result {
                case .success(let records):
                    DispatchQueue.main.async {
                        for rec in records {
                            if let sala = CKManager.getSalaFromRecord(salaRecord: rec) {
                                self.salas.append(sala)
                            }
                        }
//                        print("dao init - salas: \(self.salas.count)")
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
//        print(#function)
        var salas: [Sala] = []
        for sala in self.salas {
//            dump(sala)
            for membro in sala.membros {
                if (id == membro.usuario.id) { salas.append(sala) } 
            }
        }
        return salas
    }
    
    func getSalasWithoutUser(id: String?) -> [Sala] {
        var salasWithout: [Sala] = []
        for sala in salas {
            for membro in sala.membros {
                if (membro == sala.membros.last! && membro.usuario.id != id) {
                    salasWithout.append(sala)
                }
            }
        }
        return salasWithout
    }
    
    func getUsuario(id: String) -> Usuario? {
        for user in self.usuarios {
            if (id == user.id) { return user }
        }
        return nil
    }
    
    func addNovaSala(_ sala: Sala){
        self.salas.append(sala)
    }
    
    func addNovoUsuario(_ usuario: Usuario?){
        if let usuario = usuario {
            self.usuarios.append(usuario)
        }
        else {
            print("dao.addNovoUsuario: usuario recebido = nil")
        }
        
    }
    
    func removeSala(_ sala: Sala) {
        salas.removeAll(where: {$0.id == sala.id})
    }
}
