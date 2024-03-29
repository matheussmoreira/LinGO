//
//  Post.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

class Post: Equatable, Identifiable, ObservableObject {
    var id: String = ""
    @Published var titulo: String = ""
    @Published var descricao: String?
    @Published var link: LinkPost?
    @Published var publicador: Membro
    @Published var perguntas: [Comentario] = []
    @Published var comentarios: [Comentario] = []
    @Published var categorias: [String] = []
    @Published var tags: [String] = []
    @Published var denuncias: [String] = []
    
    @Published var allPerguntasLoaded = false
    @Published var allComentariosLoaded = false
    @Published var perguntasRef: [CKRecord.Reference] = []
    @Published var comentariosRef: [CKRecord.Reference] = []
    
    init(titulo: String?, descricao: String?, link: LinkPost?, categs: [String], tags: String, publicador: Membro) {
        self.titulo = titulo ?? "Sem título"
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

extension Post{
    static func ckLoad(from ckReference: CKRecord.Reference, salaMembros: [Membro], completion: @escaping (Result<Post?, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.fetch(
            withRecordID: ckReference.recordID) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
                guard let titulo = record["titulo"] as? String else {
                    print("\(#function) - Erro no cast do titulo do post")
                    return
                }
                guard let descricao = record["descricao"] as? String else {
                    print("\(#function) - Erro no cast da descricao do post")
                    return
                }
                guard let categs = record["categorias"] as? [String] else {
                    print("\(#function) - Erro no cast das categorias do post")
                    return
                }
                let tags = record["tags"] as? [String] ?? []
                let denuncias = record["denuncias"] as? [String] ?? []
                guard let publicador = record["publicador"] as? CKRecord.Reference else {
                    print("\(#function) - Erro no cast do publicador do post")
                    return
                }
                
                let perguntasRef = record["perguntas"] as? [CKRecord.Reference] ?? []
                let comentariosRef = record["comentarios"] as? [CKRecord.Reference] ?? []
                
                let link = record["link"] as? CKRecord.Reference
                
                CKManager.fetchMembro(recordName: publicador.recordID.recordName) { (membroResult) in
                    switch membroResult {
                        case .success(let fetchedMembro):
                            let post = Post(titulo: titulo, descricao: descricao, link: nil, categs: categs, tags: "", publicador: fetchedMembro)
                            post.tags = tags
                            post.denuncias = denuncias
                            post.id = ckReference.recordID.recordName
                            post.perguntasRef = perguntasRef
                            post.comentariosRef = comentariosRef
                            
                            if post.perguntasRef.isEmpty {
                                post.allPerguntasLoaded = true
                            }
                            if post.comentariosRef.isEmpty {
                                post.allComentariosLoaded = true
                            }
                            
                            if link != nil {
                                CKManager.fetchLink(recordName: link!.recordID.recordName) { (linkResult) in
                                    switch linkResult {
                                        case .success(let fetchedLink):
                                            post.link = fetchedLink
                                            completion(.success(post))
                                        case .failure(_):
                                            break
                                    }
                                }
                            } else {
                                completion(.success(post))
                            }
                            
                        case .failure(_):
                            print("Retornando post nil")
                            completion(.success(nil))
                            break
                    }
                }
            }
        }
    }
    
    func ckLoadAllPerguntas(){
        for ref in perguntasRef {
            Comentario.ckLoad(from: ref) { (result) in
                switch result {
                    case .success(let loadedPergunta):
                        DispatchQueue.main.async {
                            self.perguntas.append(loadedPergunta)
                            self.allPerguntasLoaded = (self.perguntas.count == self.perguntasRef.count)
                        }
                    case .failure(_):
                        break
                }
            }
        }
    }
    
    func ckLoadAllComentarios(){
        for ref in comentariosRef {
            Comentario.ckLoad(from: ref) { (result) in
                switch result {
                    case .success(let loadedComentario):
                        DispatchQueue.main.async {
                            self.comentarios.append(loadedComentario)
                            self.allComentariosLoaded = (self.comentarios.count == self.comentariosRef.count)
                        }
                    case .failure(_):
                        break
                }
            }
        }
    }
}
