//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Membro: Equatable, Identifiable, ObservableObject {
    var usuario: Usuario
    var sala: Sala
    var is_admin: Bool
    @Published var assinaturas: [Categoria] = []
    @Published var posts_salvos: [Post] = []
    @Published var posts_publicados: [Post] = []
    
    init (usuario: Usuario, sala: Sala, is_admin: Bool) {
        self.usuario = usuario
        self.sala = sala
        self.is_admin = is_admin
    }
    
    static func == (lhs: Membro, rhs: Membro) -> Bool {
        return lhs.usuario.id == rhs.usuario.id
    }
    
    func salvaPost(post: Post?) {
        if (post != nil) { self.posts_salvos.append(post!)}
        else { print("Post a ser salvo não definido") }
    }
    
    func publicaPost(post: Post?) {
        if (post != nil) { self.posts_publicados.append(post!)}
        else { print("Post a ser publicado inválido") }
    }
    
    func assinaCategoria(categoria categ: Categoria?) {
        if (categ != nil) { self.assinaturas.append(categ!) }
        else { print("Categoria a ser assinada inválida") }
    }
    
    func getAssinaturaIndex(id: Int) -> Int? {
        var idx = 0
        for asst in assinaturas {
            if asst.id == id {
                return idx
            }
            else {
              idx += 1
            }
        }
        return nil
    }
    
    func removeAssinatura(categoria categ: Categoria?) {
        if (categ != nil) {
            if let idx = getAssinaturaIndex(id: categ!.id) {
                self.assinaturas.remove(at: idx)
            }
            else {
                print("Assinatura não encontrada")
            }
        }
        else {
            print("Categoria a ser removida inválida")
        }
    }
    
    func getPostSalvoIndex(id: Int) -> Int? {
        var idx = 0
        for salvo in posts_salvos {
            if salvo.id == id {
                return idx
            }
            else {
              idx += 1
            }
        }
        return nil
    }
    
    func removePostSalvo(post: Post?) {
        if (post != nil) {
            if let idx = getPostSalvoIndex(id: post!.id) {
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
