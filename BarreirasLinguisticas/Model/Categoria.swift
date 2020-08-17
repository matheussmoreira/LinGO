//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Categoria: Equatable, Identifiable, ObservableObject {
    let id: Int
    @Published var nome: String
    @Published var tags: [Tag] = []
    @Published var posts: [Post] = []
    var assinantes: [Membro] = []
    
    init(id: Int, nome: String?) {
        self.id = id
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addTag(tag: Tag?) {
        if (tag != nil) { self.tags.append(tag!)}
        else { print("Categoria com tag inválida") }
    }
    
    func addPost(post: Post?) {
        if (post != nil) {
            self.posts.append(post!)
            //addTags2(from: post!)
        }
        else { print("Categoria com post inválido") }
    }
    
    func addAssinantes(membro memb: Membro?) {
        if (memb != nil) { self.assinantes.append(memb!)}
        else { print("Problema na assinatura por membro inválido") }
    }
    
    func addTags2(from post: Post) {
        for tag in post.tags {
            if !self.tags.contains(tag) {
                self.tags.append(tag)
            }
        }
    }
}
