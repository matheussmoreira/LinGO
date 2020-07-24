//
//  Post.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

struct Post: Identifiable {
    let id = UUID()
    var titulo: String
    var descricao: String?
    var link: LPLinkMetadata?
    //var date: ???
    var categorias: [Categoria]
    var tags: [Tag]
    let autor: Usuario
    //var comentarios: [Comentario]
    var apropriado: Bool
    
}
