//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI

class Membro: Identifiable {
    let id: Int // = UUID()
    let email: String
    var senha: String
    var nome: String
    var foto_perfil: String
    var pais: String
    var fluencia_ingles: String
    var cor_fluencia: Color {
        switch fluencia_ingles {
        case "Advanced": return .blue
        case "Intermediate": return .yellow
        case "Basic": return .green
        case "Zero": return .gray
        default: return .black
        }
    }
    var is_admin: Bool
    //var comentarios: [Comentario] = []
    var assinaturas: [Categoria] = []
    var posts_salvos: [Post] = []
    var posts_publicados: [Post] = []
    
    init(id: Int, email: String?, senha: String?, nome: String?, foto_perfil: String?, pais: String?, fluencia_ingles: String?, is_admin: Bool) {
        self.id = id
        self.email = email ?? "<membro@email.com>"
        self.senha = senha ?? "<senha>"
        self.nome = nome ?? "<nome>"
        self.foto_perfil = foto_perfil ?? "user_icon"
        self.pais = pais ?? "<pais>"
        self.fluencia_ingles = fluencia_ingles ?? "<fluencia>"
        self.is_admin = is_admin
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
        if (categ != nil) { self.assinaturas.append(categ!)}
        else { print("Categoria a ser assinada inválida") }
    }
}
