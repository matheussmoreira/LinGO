//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

class Membro: Equatable, Identifiable, ObservableObject {
    var id: String = ""
    var usuario: Usuario
    var idSala: String
    var is_admin: Bool
    @Published var assinaturas: [String] = [] //id das Categorias
    @Published var posts_salvos: [String] = [] //id dos Posts
    @Published var posts_publicados: [String] = [] //id dos Posts
    
    init (usuario: Usuario, idSala: String, is_admin: Bool) {
        self.usuario = usuario
        self.idSala = idSala
        self.is_admin = is_admin
    }
    
    static func == (lhs: Membro, rhs: Membro) -> Bool {
        return lhs.usuario.id == rhs.usuario.id
    }
    
    // MARK: - NOVOS
    func updateAdminStatus(){
        is_admin.toggle()
        CKManager.modifyMembro(membro: self) { (result) in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func assinaCategoria(categoria categ: String?) {
        if (categ != nil) {
            self.assinaturas.append(categ!)
            CKManager.modifyMembro(membro: self) { (result) in
                switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
        }
        else {
            print("Categoria a ser assinada inválida")
        }
    }
    
    func salvaPost(post: String?) {
        if (post != nil) {
            self.posts_salvos.append(post!)
            CKManager.modifyMembro(membro: self) { (result) in
                switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
        }
        else {
            print("Post a ser salvo não definido")
        }
    }
    
    func publicaPost(post: String?) {
        if (post != nil) {
            self.posts_publicados.append(post!)
            CKManager.modifyMembro(membro: self) { (result) in
                switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
            
        }
        else { print("Post a ser publicado inválido") }
    }
    
    //MARK: - DELECOES
    
    func removeAssinatura(categoria categ: String?) {
        if (categ != nil) {
            self.assinaturas.removeAll(where: {$0 == categ!})
            CKManager.modifyMembro(membro: self) { (result) in
                switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
        }
        else {
            print("Categoria a ser removida inválida")
        }
    }
    
    func apagaPost(post: String?) {
        if (post != nil) {
            posts_publicados.removeAll(where: {$0 == post})
            CKManager.modifyMembro(membro: self) { (result) in
                switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
            
        }
        else { print("Post a ser publicado inválido") }
    }
    
    func removePostSalvo(post: String?) {
        if (post != nil) {
            if let idx = getPostSalvoIndex(id: post!) {
                self.posts_salvos.remove(at: idx)
                CKManager.modifyMembro(membro: self) { (result) in
                    switch result {
                        case .success(_):
                            break
                        case .failure(let error):
                            print(#function)
                            print(error)
                    }
                }
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
        for salvo in posts_salvos {
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
        for asst in assinaturas {
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
