//
//  Resposta.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 11/12/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

class Resposta: Identifiable, ObservableObject {
    var id: String = ""
    @Published var id_original: String
    @Published var publicador: Membro
    @Published var conteudo: String
    @Published var denuncias: [String] = []
    
    init(id_original: String, publicador: Membro, conteudo: String) {
        self.id_original = id_original
        self.publicador = publicador
        self.conteudo = conteudo
    }
    
    func updateReportStatus(from membro: Membro){
        if !denuncias.contains(membro.id) {
            denuncias.append(membro.id)
        }
        else {
            denuncias.removeAll(where: {$0 == membro.id})
        }
        
        CKManager.modifyResposta(self)
    }
    
}

extension Resposta {
    static func ckLoad(from id: String, completion: @escaping (Result<Resposta, Error>) -> ()){
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: id)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
                guard let publicadorRef = record["publicador"] as? CKRecord.Reference else {
                    print("\(#function): Problema no cast do publicadorRef")
                    return
                }
                CKManager.fetchMembro(recordName: publicadorRef.recordID.recordName) { (resultMembro) in
                    switch (resultMembro) {
                        case .success(let fetchedMembro):
                            guard let id_original = record["id_original"] as? String else {
                                print("\(#function): Problema no cast do id_original")
                                return
                            }
                            guard let conteudo = record["conteudo"] as? String else {
                                print("\(#function): Problema no cast do conteudo")
                                return
                            }
                            let denuncias = record["denuncias"] as? [String] ?? []
                            
                            let resposta = Resposta(id_original: id_original, publicador: fetchedMembro, conteudo: conteudo)
                            resposta.denuncias = denuncias
                            
                            resposta.id = record.recordID.recordName
                            
                            completion(.success(resposta))
                        case .failure(let error2):
                            print("\(#function): \(error2)")
                            completion(.failure(error2))
                    }
                }
            }
        }
    }
}
