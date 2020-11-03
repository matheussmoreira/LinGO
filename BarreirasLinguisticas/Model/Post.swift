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
    var recordName: String?
    var id: String {self.recordName ?? ""}//String(self.hashValue)}
    @Published var titulo: String
    @Published var descricao: String?
    @Published var link: Link?
    @Published var link_image: UIImage?
    @Published var publicador: Membro
    @Published var perguntas: [Comentario] = []
    @Published var comentarios: [Comentario] = []
    @Published var categorias: [String] = [] //idCategorias
    @Published var tags: [String] = []
    @Published var denuncias: [Membro] = []
    
    init(titulo: String?, descricao: String?, link: Link?, categs: [String], tags: String, publicador: Membro) {
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
    
    func addCategoria(categoria: String?) {
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

    func getComentarioOriginal(id: String) -> Comentario? {
        for pergunta in self.perguntas {
            if (id == pergunta.id) { return pergunta }
        }
        for coment in self.comentarios {
            if (id == coment.id) { return coment }
        }
        return nil
    }
    
    func novoComentario(publicador: Membro, conteudo: String, is_question: Bool) {
        let comentario = Comentario(post: self, publicador: publicador, conteudo: conteudo, is_question: is_question, original: nil)
        
        if is_question {
            self.perguntas.append(comentario)
        }
        else {
            self.comentarios.append(comentario)
        }
    }
    
    func novoReply(publicador id_publicador: Membro, conteudo: String, original id_original: String) {
        if let original = self.getComentarioOriginal(id: id_original) {
            let comentario = Comentario(post: self, publicador: publicador, conteudo: conteudo, is_question: false, original: original)
            original.replies.append(comentario)
        }
        else {
            print("Reply não adicionado por comentário original não identificado")
        }
    }

    func apagaPergunta(id: String) {
        perguntas.removeAll(where: { $0.id == id})
    }
    
    func apagaComentario(id: String) {
        comentarios.removeAll(where: { $0.id == id})
    }
    
}
