//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

class Categoria: Equatable, Identifiable, ObservableObject {
    var id: String = ""
    @Published var nome: String = ""
    @Published var tagsPosts: [String] = []
    
    init(nome: String?) {
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addPostTags(post: Post) {
        for tag in post.tags{
            if !self.tagsPosts.contains(tag) {
                self.tagsPosts.append(tag)
                CKManager.modifyCategoria(self)
            }
        }
    }
    
    func removePostTags(tags: [String]) {
        for tag in tags {
            for tagPost in tagsPosts {
                if tag == tagPost {
                    tagsPosts.removeAll(where: { $0 == tag})
                }
            }
        }
        CKManager.modifyCategoria(self)
    }
    
}

//MARK: - CKManagement
extension Categoria{
    static func ckLoad(from ckReference: CKRecord.Reference, completion: @escaping (Result<Categoria, Error>) -> ()) {
//        print("\tFetching categoria")
        CKContainer.default().publicCloudDatabase.fetch(
            withRecordID: ckReference.recordID) { (fetchedRecord, error) in
//            print("\tFetch finalizado")
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
//                print("\tCategoria fetched!")
                guard let nome = record["nome"] as? String else {
                    return
                }
                let categoria = Categoria(nome: nome)
                categoria.id = record.recordID.recordName
//                print("\tRetornando categoria")
                completion(.success(categoria))
            }
        }
    }
}
