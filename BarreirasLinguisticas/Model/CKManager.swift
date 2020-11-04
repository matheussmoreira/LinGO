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
    
    static func saveUser(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()) {
        
        let userRecord = CKRecord(recordType: "Users")
        userRecord["nome"] = user.nome as CKRecordValue
        userRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(userRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                
                if let record = record {
                    let nome = record["nome"] as? String
                    let foto = record["foto_perfil"] as? UIImage
                    let fluencia = record["fluencia_ingles"] as? String
                    
                    let savedUser = Usuario(
                        nome: nome,
                        foto_perfil: Image(uiImage: foto ?? UIImage(named: "perfil")!),
                        fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                    savedUser.id = record.recordID.recordName
                    
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
                let nome = record["nome"] as? String
                let foto = record["foto_perfil"] as? UIImage
                let fluencia = record["fluencia_ingles"] as? String
                
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: Image(uiImage: foto ?? UIImage(named: "perfil")!),
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                fetchedUser.id = record.recordID.recordName
                
                completion(.success(fetchedUser))
            }
        }
    }
    
    
    
}
