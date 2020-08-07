//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Categoria: Identifiable, ObservableObject {
    let id: Int
    var nome: String
    var tags: [Tag] = []
    var posts: [Post] = []
    var assinantes: [Membro] = []
    
    init(id: Int, nome: String?) {
        self.id = id
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    func addTag(tag: Tag?) {
        if (tag != nil) { self.tags.append(tag!)}
        else { print("Categoria com tag inválida") }
    }
    
    func addPost(post: Post?) {
        if (post != nil) { self.posts.append(post!)}
        else { print("Categoria com post inválido") }
    }
    
    func addAssinantes(membro memb: Membro?) {
        if (memb != nil) { self.assinantes.append(memb!)}
        else { print("Problema na assinatura por membro inválido") }
    }
}
