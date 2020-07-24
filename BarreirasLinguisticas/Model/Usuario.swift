//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

struct Usuario: Identifiable {
    let id: Int // = UUID()
    let email: String
    var senha: String
    var nome: String
    var fotoPerfil: String
    var pais: String
    var fluenciaIngles: String
    var admin: Bool
    //var comentarios: [Comentario]
    var inscricoes: [Categoria]
    var postsSalvos: [Post]
    var postsPublicados: [Post]
}
