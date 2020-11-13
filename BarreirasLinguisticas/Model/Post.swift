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
    @Published var link_image: UIImage?
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
        else { print("Post: Não deu pra adquirir o link pois está inválido\n") }
    }
    
    func updateReportStatus(membro: Membro){
        if !denuncias.contains(membro.id) {
            denuncias.append(membro.id)
        }
        else {
            denuncias.removeAll(where: {$0 == membro.id})
        }
        CKManager.modifyPost(post: self) { (result) in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }

    func novoComentario(publicador: Membro, conteudo: String, is_question: Bool) {
        let comentario = Comentario(post: self.id, publicador: publicador, conteudo: conteudo, is_question: is_question)
        
        CKManager.saveComentario(comentario: comentario) { (result) in
            switch result {
                case .success(let id):
                    DispatchQueue.main.async {
                        comentario.id = id
                        if is_question {
                            self.perguntas.append(comentario)
                        }
                        else {
                            self.comentarios.append(comentario)
                        }
                        
                        CKManager.modifyPost(post: self) { (result2) in
                            switch result2 {
                                case .success(_):
                                    break
                                case .failure(let error2):
                                    print(#function)
                                    print(error2)
                            }
                        }
                    }
                case .failure(let error):
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
        CKManager.deleteRecord(recordName: id) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.perguntas.removeAll(where: { $0.id == id })
                        CKManager.modifyPost(post: self) { (result2) in
                            switch result2 {
                                case .success(_):
                                    break
                                case .failure(let error2):
                                    print(#function)
                                    print(error2)
                            }
                        }
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func apagaComentario(id: String) {
        CKManager.deleteRecord(recordName: id) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.comentarios.removeAll(where: { $0.id == id })
                        CKManager.modifyPost(post: self) { (result2) in
                            switch result2 {
                                case .success(_):
                                    break
                                case .failure(let error2):
                                    print(#function)
                                    print(error2)
                            }
                        }
                    }
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
