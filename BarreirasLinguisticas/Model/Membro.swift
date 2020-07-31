//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI

class Membro: Usuario {
    var is_admin: Bool
    //var comentarios: [Comentario] = []
    var assinaturas: [Categoria] = []
    var posts_salvos: [Post] = []
    var posts_publicados: [Post] = []
    
    init (usuario: Usuario, is_admin: Bool) {
        self.is_admin = is_admin
        super.init(id: usuario.id, email: usuario.email, senha: usuario.senha, nome: usuario.nome, foto_perfil: usuario.foto_perfil, pais: usuario.pais, fluencia_ingles: usuario.fluencia_ingles)
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
