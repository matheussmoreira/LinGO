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
    
}

// MARK: - USUARIO
extension CKManager {
    static func ckCreateUsuario(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()) {
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
                    guard let nome = record["nome"] as? String else {
                        print("saveUser: problema ao baixar o nome")
                        return
                    }
//                    guard let foto = record["foto_perfil"] as? UIImage else {
//                        print("saveUser: problema ao baixar a foto")
//                        return
//                    }
                    guard let fluencia = record["fluencia_ingles"] as? String else {
                        print("saveUser: problema ao baixar a fluencia")
                        return
                    }
                    
                    let savedUser = Usuario(
                        nome: nome,
                        foto_perfil: Image(uiImage: /*foto ?? */UIImage(named: "perfil")!),
                        fluencia_ingles: Usuario.pegaFluencia(nome: fluencia))
                    savedUser.id = id
                    
                    completion(.success(savedUser))
                }
            }
        }
    }
    
    static func ckFetchUsuario(recordName: String, completion: @escaping (Result<Usuario, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let record = record {
                // Pegando os dados do usuario
                let id = record.recordID.recordName
                guard let nome = record["nome"] as? String else {
                    print("fetchUser: problema ao baixar o nome")
                    return
                }
//                guard let foto = record["foto_perfil"] as? UIImage else {
//                    print("fetchUser: problema ao baixar a foto")
//                    return
//                }
                guard let fluencia = record["fluencia_ingles"] as? String else {
                    print("fetchUser: problema ao baixar a fluencia")
                    return
                }
                let sala_atual = record["sala_atual"] as? Sala // MUDAR PARA GUARD LET DEPOIS
                
                // Devolvendo os dados
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: Image(uiImage: UIImage(named: "perfil")!),//foto ),
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ))
                fetchedUser.id = id
                fetchedUser.sala_atual = sala_atual
                
                completion(.success(fetchedUser))
            }
        }
    }
    
    static func ckModifyUsuario(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()){
        
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: user.id)){ (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedRecord = record {
                fetchedRecord["nome"] = user.nome as CKRecordValue
                fetchedRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
                // FALTA A FOTO DE PERFIL !!!
                
                publicDB.save(fetchedRecord) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedRecord = record {
                        guard let nome = savedRecord["nome"] as? String else {
                            print("updateUser: problema ao baixar o nome")
                            return
                        }
//                        guard let foto = savedRecord["foto_perfil"] as? UIImage else {
//                            print("updateUser: problema ao baixar a foto")
//                            return
//                        }
                        guard let fluencia = savedRecord["fluencia_ingles"] as? String else {
                            print("updateUser: problema ao baixar a fluencia")
                            return
                        }
                        
                        let savedUser = Usuario(
                            nome: nome,
                            foto_perfil: Image(uiImage: /*foto ?? */UIImage(named: "perfil")!),
                            fluencia_ingles: Usuario.pegaFluencia(nome: fluencia))
                        savedUser.id = user.id
                        savedUser.sala_atual = user.sala_atual
                        
                        completion(.success(savedUser))
                    }
                }
            }
        }
        
    }
    
}

// MARK: - SALA
extension CKManager {
    static func ckCreateSala(nome: String, completion: @escaping (Result<Sala, Error>) -> ()) {
        let salaRecord = CKRecord(recordType: "Sala")
        salaRecord["nome"] = nome
        
        CKContainer.default().publicCloudDatabase.save(salaRecord){ (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao salvar sala no publicDB")
                completion(.failure(error))
                return
            }
            if let savedRecord = record {
                guard let nome = savedRecord["nome"] as? String else {
                    print(#function)
                    print("Problema ao baixar o nome")
                    return
                }
                let savedSala = Sala(id: savedRecord.recordID.recordName, nome: nome)
                completion(.success(savedSala))
            }
        }
    }
    
    static func ckSalaNovoMembro(sala: Sala, completion: @escaping (Result<[CKRecord.Reference], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            // BUSCA PELA SALA
            if let error = error {
                print(#function)
                print("Erro ao buscar sala")
                completion(.failure(error))
                return
            }
            if let fetchedSala = record {
                // POR ENQUANTO ESTAMOS ALTERANDO SO A RELACAO DOS MEMBROS NA SALA
                // PREPARA OS DADOS
                var membros_array: [CKRecord.Reference] = []
                for m in sala.membros {
                    if let name = m.recordName {
                        membros_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: name), action: .deleteSelf))
                    }
                }
                fetchedSala["membros"] = membros_array
                
                // ATUALIZA
                publicDB.save(fetchedSala) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedRecord = record {
                        guard let membrosReferences = savedRecord["membros"] as? [CKRecord.Reference] else {
                            print("saveNovoMembroSala: problema ao baixar os membros")
                            return
                        }
                        completion(.success(membrosReferences))
                    }
                }
            }
        }
    } //update
}

// MARK: - MEMBRO
extension CKManager {
    static func ckCreateMembro(membro: Membro, completion: @escaping (Result<Membro, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let membroRecord = CKRecord(recordType: "Membro")
        membroRecord["usuario"] = CKRecord.Reference(
            recordID: CKRecord.ID(recordName: membro.usuario.id), action: .deleteSelf
        )
        membroRecord["idSala"] = membro.idSala
        membroRecord["is_admin"] = membro.is_admin ? 1 : 0
        
        // MANDANDO SALVAR
        CKContainer.default().publicCloudDatabase.save(membroRecord) { (record, err) in
            if let err = err {
                print(#function)
                print("Erro ao salvar membro")
                completion(.failure(err))
                return
            }
            
            // RECEBENDO OS DADOS SALVOS
            if let savedMembro = record {
                if let userReference = savedMembro["usuario"] as? CKRecord.Reference {
                    ckFetchUsuario(recordName: userReference.recordID.recordName) { (result) in
                        switch result {
                            case .success(let fetchedUser):
                                DispatchQueue.main.async {
                                    guard let idSala = savedMembro["idSala"] as? String else {
                                        print(#function)
                                        print("Problema ao baixar a idSala do membro")
                                        return
                                    }
                                    guard let admin = savedMembro["is_admin"] as? Int else {
                                        print(#function)
                                        print("Problema ao baixar o is_admin do membro")
                                        return
                                    }
                                    
                                    let is_admin: Bool
                                    if admin == 1 { is_admin = true}
                                    else { is_admin = false }
                                    
                                    let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                    membro.recordName = savedMembro.recordID.recordName
                                    completion(.success(membro))
                                }
                            case .failure(let error):
                                print(#function)
                                print("fetchUser")
                                print(error)
                        }
                    }
                }
            }
        } // .save

    } // funcao
    
    static func ckFetchMembro(recordName: String, completion: @escaping (Result<Membro, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedMembro = record {
                if let usuarioReference = fetchedMembro["usuario"] as? CKRecord.Reference {
                    ckFetchUsuario(recordName: usuarioReference.recordID.recordName) { (result) in
                        switch result {
                            case .success(let fetchedUser):
                                guard let idSala = fetchedMembro["idSala"] as? String else {
                                    print("saveMembro: Problema ao baixar a idSala do membro")
                                    return
                                }
                                guard let admin = fetchedMembro["is_admin"] as? Int else {
                                    print("saveMembro: Problema ao baixar o is_admin do membro")
                                    return
                                }
                                let is_admin: Bool
                                if admin == 1 { is_admin = true}
                                else { is_admin = false }
                                
                                let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                membro.recordName = fetchedMembro.recordID.recordName
                                completion(.success(membro))
                            case .failure(let error):
                                print(error)
                        }
                    }
                }
            }
        }
    } //fetchMembro
    
}
