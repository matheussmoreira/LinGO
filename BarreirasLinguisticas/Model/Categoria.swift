//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

struct Categoria: Identifiable {
    let id: Int // = UUID()
    var nome: String
    var tags: [Tag]
    var posts: [Post]
    var inscritos: [Usuario]
}
