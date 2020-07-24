//
//  Tag.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

struct Tag: Identifiable {
    let id = UUID()
    var nome: String
    var categorias: [Categoria]
    var posts: [Post]
}
