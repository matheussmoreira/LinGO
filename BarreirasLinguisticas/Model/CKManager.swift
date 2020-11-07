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
    
    private static func getUserFromDictionary(_ userDictionaryOpt: Dictionary<String, Any>?) -> Usuario? {
        if let usuarioDictionary = userDictionaryOpt {
            let id = usuarioDictionary["recordName"] as! String
            let nome = usuarioDictionary["nome"] as? String
            let foto = Image(uiImage: UIImage(named: "perfil")!)
            let fluencia = Usuario.pegaFluencia(
                nome: usuarioDictionary["fluencia_ingles"] as! String)
            
            let usuario = Usuario(
                nome: nome,
                foto_perfil: foto,
                fluencia_ingles: fluencia
            )
            usuario.id = id
            
            return usuario
        } else {
            print(#function)
            print("usuarioDictionary is nil")
        }
        return nil
    }
    
    private static func getMembroFromDictionary(_ membroDictionaryOpt: Dictionary<String, Any>?) -> Membro? {
        if let membroDictionary = membroDictionaryOpt {
            let usuario = getUserFromDictionary( membroDictionary["usuario"]! as? Dictionary<String,Any>)
            
            let recordName = membroDictionary["recordName"] as! String
            let idSala = membroDictionary["idSala"] as! String
            let admin = membroDictionary["is_admin"] as! Int
            let is_admin: Bool
            if admin == 1 { is_admin = true }
                else { is_admin = false }
            
            let membro = Membro(usuario: usuario!, idSala: idSala, is_admin: is_admin)
            membro.recordName = recordName
            return membro
        
        } else {
            print(#function)
            print("membroDictionary is nil")
        }
        return nil
    }
    
    static func getSalaFromRecord(salaRecord: CKRecord) -> Sala? {
        guard let salaRecordName = salaRecord.asDictionary["recordName"] as? String else {
            print(#function)
            print("Erro ao capturar o recordName de uma sala")
            return nil
        }
        guard let salaNome = salaRecord.asDictionary["nome"] as? String else{
            print(#function)
            print("Erro ao capturar o nome de uma sala")
            return nil
        }
        guard let membrosDictionaries = salaRecord.asDictionary["membros"] as? Array<Optional<Dictionary<String, Any>> >else {
            print(#function)
            print("Erro no cast do vetor de membros")
            return nil
        }
        
        var membros: [Membro] = []
        for membroDictionary in membrosDictionaries {
            if let membro = getMembroFromDictionary(membroDictionary) {
                membros.append(membro)
            } else {
                print("Nao adquiriu membro do dicionario!")
            }
        }
        
        let sala = Sala(id: salaRecordName, nome: salaNome)
        sala.membros.append(contentsOf: membros)
        return sala
    }
    
    static func loadSalasRecords(completion: @escaping (Result<[CKRecord], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        let querySalas = CKQuery(recordType: "Sala", predicate: NSPredicate(value: true))
        publicDB.perform(querySalas, inZoneWith: nil) { (records, error) in
            if let  error = error {
                print(#function)
                print("Erro ao carregar salas")
                completion(.failure(error))
            }
            if let loadedSalas = records {
                completion(.success(loadedSalas))
            }
        }
    } // funcao
    
}

// MARK: - USUARIO
extension CKManager {
    static func ckSaveUsuario(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()) {
        let userRecord = CKRecord(recordType: "Users")
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
                let nome = record["nome"] as? String
//                guard let nome = record["nome"] as? String else {
//                    print("fetchUser: problema ao baixar o nome")
//                    return
//                }
//                guard let foto = record["foto_perfil"] as? UIImage else {
//                    print("fetchUser: problema ao baixar a foto")
//                    return
//                }
                let fluencia = record["fluencia_ingles"] as? String
//                guard let fluencia = record["fluencia_ingles"] as? String else {
//                    print("fetchUser: problema ao baixar a fluencia")
//                    return
//                }
                let sala_atual = record["sala_atual"] as? String 
//                let sala_atual = record["sala_atual"] as? Sala // MUDAR PARA GUARD LET DEPOIS
                
                // Devolvendo os dados
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: Image(uiImage: UIImage(named: "perfil")!),//foto ),
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
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
                fetchedRecord["sala_atual"] = (user.sala_atual ?? "") as CKRecordValue
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
                        var sala_atual = savedRecord["sala_atual"] as? String
                        if sala_atual == "" { sala_atual = nil }
                        
                        let savedUser = Usuario(
                            nome: nome,
                            foto_perfil: Image(uiImage: /*foto ?? */UIImage(named: "perfil")!),
                            fluencia_ingles: Usuario.pegaFluencia(nome: fluencia)
                        )
                        savedUser.id = user.id
                        savedUser.sala_atual = sala_atual
                        
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
    
    static func ckSalaUpdateMembros(sala: Sala, completion: @escaping (Result<[CKRecord.Reference], Error>) -> ()){
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
                            print(#function)
                            print("Problema ao baixar os membros")
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
    
    //MARK: - Delete Qualquer Coisa
    
    static func deleteRecord(recordName: String, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: CKRecord.ID(recordName: recordName)) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                if let recordID = recordID {
                    completion(.success(recordID))
                }
            }
        }
    } // delete
    
}
