//
//  Comentario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

class Comentario: Identifiable, ObservableObject {
    var id: String = ""
    @Published var post: String
    @Published var publicador: Membro
    @Published var conteudo: String
    @Published var is_question: Bool
    @Published var votos: [String] = []
    @Published var denuncias: [String] = []
    
    init(post: String, publicador: Membro, conteudo: String, is_question: Bool) {
        self.post = post
        self.publicador = publicador
        self.conteudo = conteudo
        self.is_question = is_question
    }
    
    func ganhaVoto(de membro: Membro){
        votos.append(membro.id)
        CKManager.modifyComentario(self)
    }
    
    func perdeVoto(de membro: Membro){
        votos.removeAll(where: {$0 == membro.id})
        CKManager.modifyComentario(self)
    }
    
    
    func checkVotoExists(membro: Membro) -> Bool {
        for membro_voto in votos {
            if membro_voto == membro.id {
                return true
            }
        }
        return false
    }
    
    func updateReportStatus(membro: Membro){
        if !denuncias.contains(membro.id) {
            denuncias.append(membro.id)
        }
        else {
            denuncias.removeAll(where: {$0 == membro.id})
        }
       
        CKManager.modifyComentario(self)
    }
    
}

extension Comentario {
    static func ckLoad(from reference: CKRecord.Reference, completion: @escaping (Result<Comentario, Error>) -> ()){
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: reference.recordID.recordName)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
                guard let idPublicador = record["id_publicador"] as? String else {
                    print("\(#function): Problema no cast do publicadorRef")
                    return
                }
                CKManager.fetchMembro(recordName: idPublicador) { (resultMembro) in
                    switch resultMembro {
                        case .success(let fetchedMembro):
                            let recordName = record.recordID.recordName
                            guard let post = record["post"] as? String else {
                                print("\(#function): Problema no cast do post")
                                return
                            }
                            guard let conteudo = record["conteudo"] as? String else {
                                print("\(#function): Problema no cast do conteudo")
                                return
                            }
                            guard let question = record["is_question"] as? Int else {
                                print("\(#function): Problema no cast do question")
                                return
                            }
                            
                            var is_question: Bool
                            (question == 1) ? (is_question = true) : (is_question = false)
                            let votos = record["votos"] as? [String] ?? []
                            let denuncias = record["denuncias"] as? [String] ?? []
                            
                            let comentario = Comentario(post: post, publicador: fetchedMembro, conteudo: conteudo, is_question: is_question)
                            comentario.votos = votos
                            comentario.denuncias = denuncias
                            comentario.id = recordName
                            completion(.success(comentario))
                        case .failure(let error2):
                            print(#function)
                            print(error2)
                            completion(.failure(error2))
                    }
                }
            }
        }
    }
}
