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
    @Published var tagsPosts: [String] = []
    @Published var posts: [Post] = []
    var assinantes: [Membro] = []
    
    init(id: Int, nome: String?) {
        self.id = id
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addPost(post: Post?) {
        if (post != nil) {
            self.posts.append(post!)
            addPostsTags(post: post!)
        }
        else { print("Categoria com post inválido") }
    }
    
    func addPostsTags(post: Post) {
        for tag in post.tags{
            if !self.tagsPosts.contains(tag) {
                self.tagsPosts.append(tag)
            }
        }
    }
    
    func addAssinantes(membro memb: Membro?) {
        if (memb != nil) { self.assinantes.append(memb!)}
        else { print("Problema na assinatura por membro inválido") }
    }
    
}
