//
//  Post.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class Post: Equatable, Identifiable, ObservableObject {
    
    let id: Int
    var titulo: String
    var descricao: String?
    var link: Link?
    var link_image: UIImage?
    var date = Date()
    let publicador: Membro
    var improprio = false
    var comentarios: [Comentario] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init(id: Int, titulo: String?, descricao: String?, link: Link?, categs: [Categoria], tags: [Tag], publicador: Membro) {
        self.id = id
        self.titulo = titulo ?? "Post sem título"
        self.descricao = descricao ?? ""
        self.categorias = categs
        self.tags = tags
        self.publicador = publicador
        addLink(link: link)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addCategoria(categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Post com categoria inválida") }
    }
    
    func addTag(tag: Tag?) {
        if (tag != nil) { self.tags.append(tag!) }
        else { print("Categoria com tag inválida") }
    }
    
    func addLink(link: Link?) {
        if (link != nil) { self.link = link! }
        else { print("Não deu pra adquirir o link pois está inválido\n") }
    }

    
    func getComentarioOriginal(id: Int) -> Comentario? {
        for coment in self.comentarios {
            if (id == coment.id) { return coment }
        }
        return nil
    }
    
    func novoComentario(id: Int, publicador: Membro, conteudo: String, is_question: Bool) {
        let comentario = Comentario(id: id, post: self, publicador: publicador, conteudo: conteudo, is_question: is_question, original: nil)
        self.comentarios.append(comentario)
    }
    
//    func novoReply(id: Int, publicador id_publicador: Int, post id_post: Int, conteudo: String, original id_original: Int) {
//
//            //if let original = post.getComentarioOriginal(id: id_original) {
//                let comentario = Comentario(id: id, post: self, publicador: publicador, conteudo: conteudo, is_question: false, original: original)
//                //original.replies.append(comentario)
//            //}
////            else {
////                print("Reply não adicionado por comentário original não identificado")
////            }
//
//    }
    
}
