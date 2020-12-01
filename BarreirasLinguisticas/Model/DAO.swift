//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

var dao = DAO()

class DAO: ObservableObject {
    @Published var salas: [Sala] = []
    @Published var salasRecords: [CKRecord] = []
    @Published var usuarioAtual: Usuario?
    @Published var idSalaAtual: String?
    @Published var salaAtual: Sala?
    @Published var membroAtual: Membro?
    @Published var allSalasLoaded = false
    
    fileprivate init(){
        loadSalasRecords()
    }
    
    func loadSalasRecords(){
        print("Loading todos os records das salas...")
        CKManager.querySalasRecords { (result) in
            switch result {
                case .success(let records):
                    DispatchQueue.main.async {
                        print("Records das salas carregados com sucesso!")
                        self.salasRecords.append(contentsOf: records)
                        if self.salasRecords.isEmpty {
                            self.allSalasLoaded = true
                        }
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func ckLoadAllSalas(){
        print("\nLoading all salas...")
        for record in salasRecords {
            if salaAtual != nil { // sala atual carregando separadamente
                if record.recordID.recordName == salaAtual!.id {
                    continue
                }
            }
            Sala.ckLoad(from: record, isSalaAtual: false, completion: { (loadedSala) in
                if loadedSala != nil {
                    DispatchQueue.main.async {
                        self.salas.append(loadedSala!)
                        if self.salas.count == self.salasRecords.count {
                            self.allSalasLoaded = true
                        }
                    }
                }
            })
        }
    }
    
    func getSalaRecord(from sala_id: String?) -> CKRecord? {
        let records = salasRecords.filter({$0.recordID.recordName == sala_id})
        if !records.isEmpty {
            return records[0]
        }
        return nil
    }
    
    func getSala(id: String) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
    
    func getSalasNomes() -> [String] {
        var nomes: [String] = []
        for sala in self.salas {
            nomes.append(sala.nome)
        }
        return nomes
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
