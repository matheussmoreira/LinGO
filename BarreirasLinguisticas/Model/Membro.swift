//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

class Membro: Equatable, Identifiable, ObservableObject, CKMRecord {
    var recordName: String?
    var usuario: Usuario
    var idSala: String
    var is_admin: Bool
    @Published var assinaturas: [String] = [] //idCategorias
    @Published var posts_salvos: [String] = [] //idPosts
    @Published var posts_publicados: [String] = [] //idPosts
    
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
        if (post != nil) { self.posts_publicados.append(post!)}
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
}
