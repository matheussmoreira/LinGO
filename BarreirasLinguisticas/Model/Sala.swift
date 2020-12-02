//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation
import CloudKit

class Sala: Identifiable, ObservableObject, Equatable {
    var id: String = ""
    @Published var nome: String = ""
    @Published var membros: [Membro] = []
    @Published var posts: [Post] = []
    @Published var allPostsLoaded = false
    @Published var loadingPostsError = false
    @Published var categorias: [Categoria] = []
    
    @Published var membrosRef: [CKRecord.Reference] = []
    @Published var categsRef: [CKRecord.Reference] = []
    @Published var postsRef: [CKRecord.Reference] = []
    
    init(id: String, nome: String) {
        self.id = id
        self.nome = nome
    }
    
    static func == (lhs: Sala, rhs: Sala) -> Bool {
        return lhs.id == rhs.id
    }
    
    private init(){
    }
    
    //MARK: - FUNCOES GET
    func getMembroByUser(id: String?) -> Membro? {
        for membro in self.membros {
            if (id == membro.usuario.id) { return membro }
        }
        return nil
    }
    
    func getNovoMembro(id id_membro: String?, usuario: Usuario, is_admin: Bool) -> Membro? {
        if getMembroByUser(id: usuario.id) == nil { //para nao adicionar membro repetido
            let membro = Membro(usuario: usuario, idSala: self.id, is_admin: is_admin)
            return membro
        }
        return nil
    }
    
    func getCategoria(id: String) -> Categoria? {
        for categ in self.categorias {
            if (id == categ.id) { return categ }
        }
        return nil
    }
    
    func getCategorias(ids: [String]) -> [Categoria] {
        var categorias: [Categoria] = []
        for id in ids {
            for categ in self.categorias {
                if (id == categ.id) { categorias.append(categ) }
            }
        }
        return categorias
    }
    
    func getCategsIds(of selectedCategories: [Categoria]) -> [String] {
        var categsId: [String] = []
        for categ in selectedCategories {
            categsId.append(categ.id)
        }
        return categsId
    }
//    func getIdsCategorias(ids: [String]) -> [String] {
//        var categorias: [String] = []
//        for id in ids {
//            for categ in self.categorias {
//                if (id == categ.id) { categorias.append(categ.id) }
//            }
//        }
//        return categorias
//    }
    
    func getPost(id: String) -> Post? {
        for post in self.posts {
            if (id == post.id) { return post }
        }
        return nil
    }
    
    func getIdPost(id: String) -> String? {
        for post in self.posts {
            if (id == post.id) { return post.id }
        }
        return nil
    }
    
    func getPostsByCategorie(categ: String) -> [Post] {
        var posts: [Post] = []
        
        for post in self.posts {
            for cat in post.categorias {
                if cat == categ {
                    posts.append(post)
                }
            }
        }
        
        return posts
    }
    
    //MARK: - NOVOS OBJETOS
    
    func novoMembro(id id_membro: String?, usuario: Usuario, is_admin: Bool) {
        if getMembroByUser(id: usuario.id) == nil { //para nao adicionar membro repetido
            let membro = Membro(usuario: usuario, idSala: self.id, is_admin: is_admin)
            self.membros.append(membro)
        }
    }
    
    func novoAdmin(membro: Membro) {
        membro.isAdmin = true
    }
    
    func novaCategoria(_ categoria: Categoria) {
        self.categorias.append(categoria)
    }
    
    func preparaNovoPost(publicador id_membro: String?, titulo: String, descricao: String?, linkString: String, categs: [String], tags: String) {
        print(#function)
        
        guard let membro = getMembroByUser(id: id_membro) else {
            print("Sala novoPost: Impossível criar o post pois o membro publicador não existe")
            return
        }
        
        if linkString == "" {
            salvaNovoPost(membro: membro, titulo: titulo, descricao: descricao, link: nil, categs: categs, tags: tags)
        }
        else {
            let _ = LinkPost(urlString: linkString) { linkResult in
                switch linkResult {
                    case .success(let linkMontado):
                        CKManager.saveLink(link: linkMontado) { (result) in
                            switch result {
                                case .success(let savedLinkRecordName):
                                    linkMontado.ckRecordName = savedLinkRecordName
                                    self.salvaNovoPost(membro: membro, titulo: titulo, descricao: descricao, link: linkMontado, categs: categs, tags: tags)
                                    CKManager.modifyLink(link: linkMontado)
                                case .failure(let error2):
                                    print(#function)
                                    print(error2)
                                    self.salvaNovoPost(membro: membro, titulo: titulo, descricao: descricao, link: nil, categs: categs, tags: tags)
                            }
                        }
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
        }
    }
    
    private func salvaNovoPost(membro: Membro, titulo: String, descricao: String?, link: LinkPost?, categs: [String], tags: String){
        
        let post = Post(titulo: titulo, descricao: descricao, link: link, categs: categs, tags: tags, publicador: membro)
        
        CKManager.savePost(post: post) { (result) in
            switch result {
                case .success(let recordName):
                    DispatchQueue.main.async {
                        post.id = recordName
                        self.addPostSalaMembro(post: post, membro: membro)
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    private func addPostSalaMembro(post savedPost: Post, membro: Membro){
        self.posts.append(savedPost)
        // ATUALIZA O VETOR DE POSTS DA SALA
        CKManager.modifySalaPosts(sala: self) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        // atualiza no CK dentro dessa funcao
                        membro.publicaPost(post: savedPost.id)
                        
                        // atualiza no CK dentro dessa funcao
                        for categ in self.categorias {
                            categ.addPostTags(post: savedPost)
                        }
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func novoComentario(id: Int, publicador id_publicador: String?, post id_post: String, conteudo: String, is_question: Bool) {
        if let publicador = getMembroByUser(id: id_publicador), let post = getPost(id: id_post)  {
            post.novoComentario(publicador: publicador, conteudo: conteudo, is_question: is_question)
        }
        else {
            print("Comentário não adicionado por publicador não identificado")
        }
    }
    
    func novaAssinatura(membro id_membro: String?, categoria: String) {
        let membro = getMembroByUser(id: id_membro)
        let categ = getCategoria(id: categoria)
        
        membro?.assinaCategoria(categoria: categ?.id)
        //        categ?.addAssinantes(membro: membro)
    }
    
    //MARK: - DELECOES
    func excluiPost3(post: Post) {
        // Apaga os atributos do post
        if post.link != nil {
            CKManager.deleteRecord(recordName: post.link!.ckRecordName)
        }
        for comentario in post.comentarios {
            CKManager.deleteRecord(recordName: comentario.id)
        }
        for pergunta in post.perguntas {
            CKManager.deleteRecord(recordName: pergunta.id)
        }
        CKManager.deleteRecord(recordName: post.id)
    }
    
    func excluiPost2(post: Post, membro: Membro) {
        // Apaga os atributos do post
        if post.link != nil {
            CKManager.deleteRecord(recordName: post.link!.ckRecordName)
        }
        for comentario in post.comentarios {
            CKManager.deleteRecord(recordName: comentario.id)
        }
        for pergunta in post.perguntas {
            CKManager.deleteRecord(recordName: pergunta.id)
        }
        CKManager.deleteRecord(recordName: post.id)

        // Atualiza vetores em que este post esta
        posts.removeAll(where: { $0.id == post.id})
        CKManager.modifySalaPosts(sala: self) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        // atualiza no CK dentro dessa funcao
                        membro.apagaPost(post: post.id)
                        
                        // atualiza no CK dentro dessa funcao
                        for categ in self.categorias {
                            categ.removePostTags(tags: post.tags)
                        }
                        
                    }
                case .failure(let error2):
                    print(#function)
                    print(error2)
            }
        }

    }
    
    func excluiPost(post: Post, membro: Membro){
        if post.link != nil {
            CKManager.deleteRecordCompletion(recordName: post.link!.ckRecordName) { (result) in
                switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            CKManager.deleteRecordCompletion(recordName: post.id) { (result2) in
                                switch result2 {
                                    case .success(_):
                                        self.removePostSalaMembro(
                                            id_post: post.id,
                                            membro: membro
                                        )
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
        } else {
            CKManager.deleteRecordCompletion(recordName: post.id) { (result) in
                switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.removePostSalaMembro(
                                id_post: post.id,
                                membro: membro
                            )
                        }
                    case .failure(let error):
                        print(#function)
                        print(error)
                }
            }
        }
    }
    
    func excluiCategoria(_ categ: Categoria) {
        CKManager.deleteRecord(recordName: categ.id)
        categorias.removeAll(where: {$0.id == categ.id})
        CKManager.modifySala(self)
    }
    
    private func removePostSalaMembro(id_post: String, membro: Membro){
        let post_resgatado = self.getPost(id: id_post)
        posts.removeAll(where: { $0.id == id_post})
        CKManager.modifySalaPosts(sala: self) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        // atualiza no CK dentro dessa funcao
                        membro.apagaPost(post: id_post)
                        
                        // atualiza no CK dentro dessa funcao
                        if let post = post_resgatado {
                            for categ in self.categorias {
                                categ.removePostTags(tags: post.tags)
                            }
                        }
                    }
                case .failure(let error2):
                    print(#function)
                    print(error2)
            }
        }
    }
    
    func removeMembro(membro id_membro: String) {
        self.membros.removeAll(where: {$0.id == id_membro})
    }
    
}

// MARK: - CKManagement
extension Sala {
    static func ckLoadEmpty(from ckRecord: CKRecord, completion: @escaping (Sala?) -> ()) {
        let sala = Sala()
        sala.id = ckRecord.recordID.recordName
        sala.nome = ckRecord["nome"] as? String ?? ""
        print("Loading sala \(sala.nome)")
        print("Retornando sala \(sala.nome)")
        completion(sala)
    }
    
    static func ckLoad(from ckRecord: CKRecord, completion: @escaping (Sala?) -> ()) {
        var loadingError = false
        let sala = Sala()
        sala.id = ckRecord.recordID.recordName
        sala.nome = ckRecord["nome"] as? String ?? ""
        print("Loading sala \(sala.nome)...")
        
        let membrosRef = ckRecord["membros"] as? [CKRecord.Reference] ?? []
        let categsRef = ckRecord["categorias"] as? [CKRecord.Reference] ?? []
        let postsRef = ckRecord["posts"] as? [CKRecord.Reference] ?? []
        if postsRef.isEmpty {
            sala.allPostsLoaded = true
        }
        
        sala.membrosRef = membrosRef
        sala.categsRef = categsRef
        sala.postsRef = postsRef
        
//        print("\tPegando membros...")
        for membroRef in membrosRef {
            Membro.ckLoad(from: membroRef) { (result) in
                switch result {
                    case .success(let loadedMembro):
                        sala.membros.append(loadedMembro)
                    case .failure(_):
                        loadingError = true
                }
            }
        }
        
//        print("\tPegando categorias...")
        for categRef in categsRef {
            Categoria.ckLoad(from: categRef) { (result) in
                switch result {
                    case .success(let loadedCateg):
                        sala.categorias.append(loadedCateg)
                    case .failure(_):
                        loadingError = true
                }
            }
        }
        
//        print("\tPegando posts...")
        for postRef in postsRef {
            Post.ckLoad(from: postRef, salaMembros: sala.membros) { (result) in
                switch result {
                    case .success(let loadedPost):
                        if loadedPost != nil {
                            DispatchQueue.main.async {
                                sala.posts.append(loadedPost!)
                                if sala.posts.count == postsRef.count {
                                    sala.allPostsLoaded = true
                                }
                            }
                        }
                    case .failure(_):
                        sala.loadingPostsError = true
                }
            }
        }
        
        while true { // espera pra retornar a sala quando carrega membros e categs
            if sala.membros.count == membrosRef.count && sala.categorias.count == categsRef.count && !loadingError {
                print("Retornando sala \(sala.nome)!")
                completion(sala)
                break
            }
        }
    }
    
    func contemUsuarioAtual() -> Bool {
        for membro in membros {
            if (id == membro.usuario.id) { return true }
        }
        return false
    }
}
