//
//  Post.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class Post: Identifiable, ObservableObject {
    let id: Int // = UUID()
    var titulo: String
    var descricao: String?
    var link: Link?
    //var date = Date()
    let publicador: Usuario
    var improprio: Bool
    //var comentarios: [Comentario] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init(id: Int, titulo: String?, descricao: String?, link: Link?, publicador: Usuario, improprio: Bool) {
        self.id = id
        self.titulo = titulo ?? "<Titulo Post>"
        self.descricao = descricao ?? ""
        self.link = link
        self.publicador = publicador
        self.improprio = improprio
    }
    
    func addCategoria (categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Post com categoria inválida") }
    }
    
    func addTag (tag: Tag?) {
        if (tag != nil) { self.tags.append(tag!)}
        else { print("Categoria com tag inválida") }
    }
    
    func addLink (link: Link?) {
        if (link != nil) { self.link = link!/*; print("\nTitulo-Metadado no addLink: \(link?.metadata?.title ?? "O metadado titulo nao existe mesmo")\n")*/}
        else { print("Não deu pra adquirir o link, pois está inválido")}
    }
    
}
