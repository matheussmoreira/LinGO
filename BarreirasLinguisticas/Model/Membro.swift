//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

class Membro: Equatable, Identifiable, ObservableObject {
    var id: String = ""
    var usuario: Usuario
    var idSala: String
    var isAdmin: Bool
    @Published var idsAssinaturas: [String] = []
    @Published var idsPostsSalvos: [String] = []
    @Published var idsPostsPublicados: [String] = []
    @Published var reports: [String] = []
    @Published var isBlocked = false
    
    init (usuario: Usuario, idSala: String, is_admin: Bool) {
        self.usuario = usuario
        self.idSala = idSala
        self.isAdmin = is_admin
    }
    
    static func == (lhs: Membro, rhs: Membro) -> Bool {
        return lhs.usuario.id == rhs.usuario.id
    }
    
    // MARK: - NOVOS
    func updateAdminStatus(){
        isAdmin.toggle()
        CKManager.modifyMembro(membro: self)
    }
    
    func updateBlockedStatus(){
        isBlocked.toggle()
        CKManager.modifyMembro(membro: self)
    }
    
    func assinaCategoria(categoria categ: String?) {
        if (categ != nil) {
            self.idsAssinaturas.append(categ!)
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Categoria a ser assinada inválida")
        }
    }
    
    func salvaPost(post: String?) {
        if (post != nil) {
            self.idsPostsSalvos.append(post!)
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Post a ser salvo não definido")
        }
    }
    
    func publicaPost(post: String?) {
        if (post != nil) {
            self.idsPostsPublicados.append(post!)
            CKManager.modifyMembro(membro: self)
        }
        else { print("Post a ser publicado inválido") }
    }
    
    //MARK: - DELECOES
    
    func removeAssinatura(categoria categ: String?) {
        if (categ != nil) {
            self.idsAssinaturas.removeAll(where: {$0 == categ!})
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Categoria a ser removida inválida")
        }
    }
    
    func apagaPost(post: String?) {
        if (post != nil) {
            idsPostsPublicados.removeAll(where: {$0 == post})
            CKManager.modifyMembro(membro: self)
        }
        else { print("Post a ser publicado é inválido") }
    }
    
    func removePostSalvo(post: String?) {
        if (post != nil) {
            if let idx = getPostSalvoIndex(id: post!) {
                self.idsPostsSalvos.remove(at: idx)
                CKManager.modifyMembro(membro: self)
            }
            else {
                print("Post salvo não encontrado")
            }
        }
        else {
            print("Posts salvo a ser removido inválido")
        }
    }
    
    //MARK: - FUNCOES GET
    func getPostSalvoIndex(id: String?) -> Int? {
        var idx = 0
        for salvo in idsPostsSalvos {
            if salvo == id {
                return idx
            }
            else {
                idx += 1
            }
        }
        return nil
    }
    
    func getAssinaturaIndex(id: String) -> Int? {
        var idx = 0
        for asst in idsAssinaturas {
            if asst == id {
                return idx
            }
            else {
                idx += 1
            }
        }
        return nil
    }
    
}

//MARK: - CKManagement
extension Membro {
    static func ckLoad(from ckReference: CKRecord.Reference, completion: @escaping (Result<Membro, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: ckReference.recordID.recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedMembro = record {
                if let usuarioReference = fetchedMembro["usuario"] as? CKRecord.Reference {
                    CKManager.fetchUsuario(recordName: usuarioReference.recordID.recordName) { (result) in
                        switch result {
                            case .success(let fetchedUser):
                                guard let idSala = fetchedMembro["idSala"] as? String else {
                                    print(#function)
                                    print("Problema ao baixar a idSala do membro")
                                    return
                                }
                                guard let admin = fetchedMembro["is_admin"] as? Int else {
                                    print(#function)
                                    print("Problema ao baixar o is_admin do membro")
                                    return
                                }
                                let publicados = fetchedMembro["posts_publicados"] as? [String] ?? []
//                                guard let publicados = fetchedMembro["posts_publicados"] as? [String] else {
//                                    print(#function)
//                                    print("Problema ao baixar posts publicados do membro do \(fetchedUser.nome)")
//                                    return
//                                }
                                let salvos = fetchedMembro["posts_salvos"] as? [String] ?? []
//                                guard let salvos = fetchedMembro["posts_salvos"] as? [String] else {
//                                    print(#function)
//                                    print("Problema ao baixar posts salvos do membro")
//                                    return
//                                }
                                let assinaturas = fetchedMembro["assinaturas"] as? [String] ?? []
//                                guard let assinaturas = fetchedMembro["assinaturas"] as? [String] else {
//                                    print(#function)
//                                    print("Problema ao baixar assinaturas do membro")
//                                    return
//                                }
                                guard let blocked = fetchedMembro["isBlocked"] as? Int else {
                                    print(#function)
                                    print("Problema ao baixar o isBlocked do membro")
                                    return
                                }
                                
                                let is_admin: Bool
                                if admin == 1 { is_admin = true}
                                    else { is_admin = false }
                                
                                let is_blocked: Bool
                                if blocked == 1 { is_blocked = true}
                                    else { is_blocked = false }
                                
                                let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                membro.id = fetchedMembro.recordID.recordName
                                membro.isBlocked = is_blocked
                                membro.idsPostsPublicados = publicados
                                membro.idsPostsSalvos = salvos
                                membro.idsAssinaturas = assinaturas
                                
                                completion(.success(membro))
                            case .failure(let error):
                                print(#function)
                                print(error)
                        }
                    }
                }
            }
        }
    } //fetchMembro
}
