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
    var id: String = ""
    @Published var titulo: String
    @Published var descricao: String?
    @Published var link: LinkPost?
//    @Published var link_image: UIImage?
    @Published var publicador: Membro
    @Published var perguntas: [Comentario] = []
    @Published var comentarios: [Comentario] = []
    @Published var categorias: [String] = []
    @Published var tags: [String] = []
    @Published var denuncias: [String] = []
    
    init(titulo: String?, descricao: String?, link: LinkPost?, categs: [String], tags: String, publicador: Membro) {
        self.titulo = titulo ?? "Post sem título"
        self.descricao = descricao ?? ""
        self.categorias = categs
        self.publicador = publicador
        addLink(link)
        if tags != "" {
            self.tags = splitTags(tags)
        }
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    //MARK: - NOVOS E OUTRAS ACOES
    func addCategoria(categoria: String?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Post com categoria inválida") }
    }
    
    func splitTags(_ tags: String) -> [String] {
        return tags.components(separatedBy: " ")
    }
    
    func addLink(_ link: LinkPost?) {
        if (link != nil) { self.link = link! }
//        else { print("Post: Não deu pra adquirir o link pois está inválido\n") }
    }
    
    func updateReportStatus(membro: Membro){
        if !denuncias.contains(membro.id) {
            denuncias.append(membro.id)
        }
        else {
            denuncias.removeAll(where: {$0 == membro.id})
        }
        CKManager.modifyPost(self)
    }

    func novoComentario(publicador: Membro, conteudo: String, is_question: Bool) {
        let comentario = Comentario(post: self.id, publicador: publicador, conteudo: conteudo, is_question: is_question)
        
        if is_question { self.perguntas.append(comentario) }
            else { self.comentarios.append(comentario) }
        
        CKManager.saveComentario(comentario: comentario) { (result) in
            switch result {
                case .success(let id):
                    DispatchQueue.main.async {
                        if is_question { self.perguntas.removeLast() }
                            else { self.comentarios.removeLast() }
                        
                        comentario.id = id
                        if is_question { self.perguntas.append(comentario) }
                            else { self.comentarios.append(comentario) }
                        
                        CKManager.modifyPost(self)
                    }
                case .failure(let error):
                    if is_question { self.perguntas.removeLast() }
                        else { self.comentarios.removeLast() }
                    print(#function)
                    print(error)
            }
        }
        
    }
    
//    func novoReply(publicador id_publicador: Membro, conteudo: String, original id_original: String) {
//        if let original = self.getComentarioOriginal(id: id_original) {
//            let comentario = Comentario(post: self, publicador: publicador, conteudo: conteudo, is_question: false)
//            comentario.original = original
//            original.replies.append(comentario)
//        }
//        else {
//            print("Reply não adicionado por comentário original não identificado")
//        }
//    }

    //MARK: - DELECOES
    func apagaPergunta(id: String) {
        self.perguntas.removeAll(where: { $0.id == id })
        CKManager.deleteRecordCompletion(recordName: id) { (result) in
            switch result {
                case .success(_):
                    CKManager.modifyPost(self)
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func apagaComentario(id: String) {
        self.comentarios.removeAll(where: { $0.id == id })
        CKManager.deleteRecordCompletion(recordName: id) { (result) in
            switch result {
                case .success(_):
                    CKManager.modifyPost(self)
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    //MARK: - FUNCOES GET
    func getComentarioOriginal(id: String) -> Comentario? {
        for pergunta in self.perguntas {
            if (id == pergunta.id) { return pergunta }
        }
        for coment in self.comentarios {
            if (id == coment.id) { return coment }
        }
        return nil
    }
    
}
