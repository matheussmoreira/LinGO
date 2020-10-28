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
    //var recordName: String?
    
    let id: Int
    @Published var titulo: String
    @Published var descricao: String?
    @Published var link: Link?
    @Published var link_image: UIImage?
    @Published var publicador: Membro
    @Published var perguntas: [Comentario] = []
    @Published var comentarios: [Comentario] = []
    @Published var categorias: [Categoria] = []
    @Published var tags: [String] = []
    @Published var denuncias: [Membro] = []
    
    init(id: Int, titulo: String?, descricao: String?, link: Link?, categs: [Categoria], tags: String, publicador: Membro) {
        self.id = id
        self.titulo = titulo ?? "Post sem título"
        self.descricao = descricao ?? ""
        self.categorias = categs
        self.publicador = publicador
        addLink(link)
        self.tags = splitTags(tags)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addCategoria(categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Post com categoria inválida") }
    }
    
    func splitTags(_ tags: String) -> [String] {
        return tags.components(separatedBy: " ")
    }
    
    func addLink(_ link: Link?) {
        if (link != nil) { self.link = link! }
        else { print("Não deu pra adquirir o link pois está inválido\n") }
    }

    func getComentarioOriginal(id: Int) -> Comentario? {
        for pergunta in self.perguntas {
            if (id == pergunta.id) { return pergunta }
        }
        for coment in self.comentarios {
            if (id == coment.id) { return coment }
        }
        return nil
    }
    
    func novoComentario(id: Int, publicador: Membro, conteudo: String, is_question: Bool) {
        let comentario = Comentario(id: id, post: self, publicador: publicador, conteudo: conteudo, is_question: is_question, original: nil)
        
        if is_question {
            self.perguntas.append(comentario)
        }
        else {
            self.comentarios.append(comentario)
        }
    }
    
    func novoReply(id: Int, publicador id_publicador: Membro, conteudo: String, original id_original: Int) {
        if let original = self.getComentarioOriginal(id: id_original) {
            let comentario = Comentario(id: id, post: self, publicador: publicador, conteudo: conteudo, is_question: false, original: original)
            original.replies.append(comentario)
        }
        else {
            print("Reply não adicionado por comentário original não identificado")
        }
    }

    func apagaPergunta(id: Int) {
        perguntas.removeAll(where: { $0.id == id})
    }
    
    func apagaComentario(id: Int) {
        comentarios.removeAll(where: { $0.id == id})
    }
}
