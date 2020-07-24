//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class DAO: ObservableObject {
    let id = UUID()
    var nome: String
    var usuarios: [Usuario] = []
    var posts: [Post] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init() {
        self.nome = "Sala 1"
        /*
        // USUARIOS
        self.usuarios.append(Usuario(email: <#T##String#>, senha: <#T##String#>, nome: <#T##String#>, pais: <#T##String#>, fluenciaIngles: <#T##String#>, admin: <#T##Bool#>, inscricoes: <#T##[Categoria]#>, postsSalvos: <#T##[Post]#>, postsPublicados: <#T##[Post]#>))
        
        // POSTS
        self.posts.append(Post(titulo: <#T##String#>, descricao: <#T##String?#>, link: <#T##LPLinkMetadata?#>, categorias: <#T##[Categoria]#>, tags: <#T##[Tag]#>, autor: <#T##Usuario#>, apropriado: <#T##Bool#>))
        
        // CATEGORIAS
        self.categorias.append(Categoria(nome: <#T##String#>, tags: <#T##[Tag]#>, posts: <#T##[Post]#>, inscritos: <#T##[Usuario]#>))
        
        // TAGS
        self.tags.append(Tag(nome: <#T##String#>, categorias: <#T##[Categoria]#>, posts: <#T##[Post]#>))
        */
    }
}
