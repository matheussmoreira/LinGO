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
    
    func salvaPost(post: String?) {
        if (post != nil) { self.posts_salvos.append(post!)}
        else { print("Post a ser salvo não definido") }
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
    
    func assinaCategoria(categoria categ: String?) {
        if (categ != nil) { self.assinaturas.append(categ!) }
        else { print("Categoria a ser assinada inválida") }
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
    
    func removeAssinatura(categoria categ: String?) {
        if (categ != nil) {
            self.assinaturas.removeAll(where: {$0 == categ!})
            
        }
        else {
            print("Categoria a ser removida inválida")
        }
    }
    
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
    
    func removePostSalvo(post: String?) {
        if (post != nil) {
            if let idx = getPostSalvoIndex(id: post!) {
                self.posts_salvos.remove(at: idx)
            }
            else {
                print("Post salvo não encontrado")
            }
        }
        else {
            print("Posts salvo a ser removido inválido")
        }
    }
    
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
    
}
