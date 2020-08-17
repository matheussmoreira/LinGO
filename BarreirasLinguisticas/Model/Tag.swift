//
//  Tag.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Tag: Equatable, Identifiable, ObservableObject {
    let id: Int
    @Published var nome: String
    var categorias: [Categoria] = []
    var posts: [Post] = []
    
    init(id: Int, nome: String?, categorias: [Categoria]) {
        self.id = id
        self.nome = nome ?? "<Nome Tag>"
        self.categorias.append(contentsOf: categorias)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addCategoria(categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Tag com categoria inválida") }
    }
    
    func addPost (post: Post?) {
        if (post != nil) { self.posts.append(post!)}
        else { print("Categoria com post inválido") }
    }
    
}
