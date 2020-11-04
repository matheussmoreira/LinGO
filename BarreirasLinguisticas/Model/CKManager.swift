//
//  CKManager.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI
import UIKit

struct CKManager {
    // saveUser com erro
    static func saveUser(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()) {
        
        let userRecord = CKRecord(recordType: "Usuario")
        userRecord["nome"] = user.nome as CKRecordValue
        userRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
        // falta a foto de perfil
        
        CKContainer.default().publicCloudDatabase.save(userRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                
                if let record = record {
                    let id = record.recordID.recordName
                    let nome = record["nome"] as? String
                    let foto = record["foto_perfil"] as? UIImage
                    let fluencia = record["fluencia_ingles"] as? String
                    
                    let savedUser = Usuario(
                        nome: nome,
                        foto_perfil: Image(uiImage: foto ?? UIImage(named: "perfil")!),
                        fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                    savedUser.id = id
                    
                    completion(.success(savedUser))
                }
            }
        }
    }
    
    static func fetchUser(recordName: String, completion: @escaping (Result<Usuario, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let record = record {
                // Pegando os dados do usuario
                let id = record.recordID.recordName
                let nome = record["nome"] as? String
                let foto = record["foto_perfil"] as? UIImage
                let fluencia = record["fluencia_ingles"] as? String
                let sala_atual = record["sala_atual"] as? Sala
                
                // Devolvendo os dados
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: Image(uiImage: foto ?? UIImage(named: "perfil")!),
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                fetchedUser.id = id
                fetchedUser.sala_atual = sala_atual
                
                completion(.success(fetchedUser))
            }
        }
    }
    
    static func updateUser(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()){
        
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: user.id)){ (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedRecord = record {
                fetchedRecord["nome"] = user.nome as CKRecordValue
                fetchedRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
//                if let sala = user.sala_atual {
//                    fetchedRecord["sala_atual"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: sala.id), action: .none)
//                }
                // FALTA A FOTO DE PERFIL !!!
                
                publicDB.save(fetchedRecord) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedRecord = record {
                        let id = savedRecord.recordID.recordName
                        let nome = savedRecord["nome"] as? String
                        let foto = savedRecord["foto_perfil"] as? UIImage
                        let fluencia = savedRecord["fluencia_ingles"] as? String
                        
                        let savedUser = Usuario(
                            nome: nome,
                            foto_perfil: Image(uiImage: foto ?? UIImage(named: "perfil")!),
                            fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                        savedUser.id = id
                        savedUser.sala_atual = user.sala_atual //SOLUCAO DE CONTORNO ??
                        
                        completion(.success(savedUser))
                    }
                }
            }
        }
        
    }
    
}
