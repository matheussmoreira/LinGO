//
//  Tag.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Tag: Identifiable {
    let id: Int // = UUID()
    var nome: String
    var categorias: [Categoria] = [] // tem necessidade ???
    var posts: [Post] = []
    
    init(id: Int, nome: String?) {
        self.id = id
        self.nome = nome ?? "<Nome Tag>"
    }
    
    func addCategoria (categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Tag com categoria inválida") }
    }
    
    func addPost (post: Post?) {
        if (post != nil) { self.posts.append(post!)}
        else { print("Categoria com post inválido") }
    }
    
}
