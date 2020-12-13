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
    @Published var quantComentarios = 0
    @Published var quantComentariosBaixados = 0
    @Published var allComentariosLoaded = false
    @Published var tentouBaixarPosts = false
    
    init(id: String, nome: String) {
        self.id = id
        self.nome = nome
    }
    
    private init(){
    }
    
    static func == (lhs: Sala, rhs: Sala) -> Bool {
        return lhs.id == rhs.id
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
    
    func salvaPostLink(publicador id_membro: String?, titulo: String, descricao: String?, linkString: String, categs: [String], tags: String) {
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
        
        post.allPerguntasLoaded = true
        post.allComentariosLoaded = true
        
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
    
    func novaAssinatura(membro id_membro: String?, categoria: String) {
        let membro = getMembroByUser(id: id_membro)
        let categ = getCategoria(id: categoria)
        
        membro?.assinaCategoria(categoria: categ?.id)
        //        categ?.addAssinantes(membro: membro)
    }
    
    //MARK: - DELECOES
    func removePost2(post: Post) {
        // Apaga os atributos do post
        if post.link != nil {
            CKManager.deleteRecord(recordName: post.link!.ckRecordName)
        }
        for comentario in post.comentarios {
            CKManager.deleteRecord(recordName: comentario.id)
        }
        for pergunta in post.perguntas {
            for resp in pergunta.respostas {
                CKManager.deleteRecord(recordName: resp.id)
            }
            CKManager.deleteRecord(recordName: pergunta.id)
        }
        CKManager.deleteRecord(recordName: post.id)
    }
    
    func removePost(post: Post, membro: Membro) {
        // Apaga os atributos do post
        if post.link != nil {
            CKManager.deleteRecord(recordName: post.link!.ckRecordName)
        }
        for comentario in post.comentarios {
            CKManager.deleteRecord(recordName: comentario.id)
        }
        for pergunta in post.perguntas {
            for resp in pergunta.respostas {
                CKManager.deleteRecord(recordName: resp.id)
            }
            CKManager.deleteRecord(recordName: pergunta.id)
        }
        CKManager.deleteRecord(recordName: post.id)
        
        // Atualiza dos vetores de posts da sala e de publicados do membro
        posts.removeAll(where: { $0.id == post.id})
        CKManager.modifySalaPosts(sala: self) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        // Atualizacao do CK dentro dessas funções
                        membro.removePostPublicado(post: post.id)
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
    
    func excluiCategoria(_ categ: Categoria) {
        CKManager.deleteRecord(recordName: categ.id)
        categorias.removeAll(where: {$0.id == categ.id})
        CKManager.modifySala(self)
    }
    
    func removeMembro(membro id_membro: String) {
        self.membros.removeAll(where: {$0.id == id_membro})
    }
    
    func regraDoAdmin(){
        if membros.count == 1 && !membros[0].isAdmin {
            membros[0].isAdmin = true
            CKManager.modifyMembro(membro: membros[0])
        }
    }
    
}

// MARK: - CKManagement
extension Sala {
    static func ckLoad(from ckRecord: CKRecord, isSalaAtual: Bool, completion: @escaping (Sala?) -> ()) {
        var loadingError = false
        let sala = Sala()
        let membrosRef = ckRecord["membros"] as? [CKRecord.Reference] ?? []
        let categsRef = ckRecord["categorias"] as? [CKRecord.Reference] ?? []
        let postsRef = ckRecord["posts"] as? [CKRecord.Reference] ?? []
        if postsRef.isEmpty { sala.allPostsLoaded = true }
        
        sala.id = ckRecord.recordID.recordName
        sala.nome = ckRecord["nome"] as? String ?? ""
        sala.quantComentarios = ckRecord["quantComentarios"] as? Int ?? 0
        if sala.quantComentarios == 0 { sala.allComentariosLoaded = true }
        
        sala.membrosRef = membrosRef
        sala.categsRef = categsRef
        sala.postsRef = postsRef
        
        for membroRef in membrosRef {
            Membro.ckLoad(from: membroRef) { (result) in
                switch result {
                    case .success(let loadedMembro):
                        DispatchQueue.main.async {
                            sala.membros.append(loadedMembro)
                        }
                    case .failure(_):
                        print("Loading error nos membros da sala \(sala.nome)!")
                        loadingError = true
                }
            }
        }
        
        for categRef in categsRef {
            Categoria.ckLoad(from: categRef) { (result) in
                switch result {
                    case .success(let loadedCateg):
                        DispatchQueue.main.async {
                            sala.categorias.append(loadedCateg)
                        }
                    case .failure(_):
                        print("Loading error nas categorias da sala \(sala.nome)!")
                        loadingError = true
                }
            }
        }
        
        if isSalaAtual {
            print("Baixando posts da sala \(sala.nome)")
            sala.tentouBaixarPosts = true
            for postRef in postsRef {
                Post.ckLoad(from: postRef, salaMembros: sala.membros) { (result) in
                    switch result {
                        case .success(let loadedPost):
                            if let loadedPost = loadedPost {
                                DispatchQueue.main.async {
                                    sala.posts.append(loadedPost)
                                    loadedPost.ckLoadAllPerguntas(sala: sala)
                                    loadedPost.ckLoadAllComentarios(sala: sala)
                                    sala.allPostsLoaded = (sala.posts.count == postsRef.count)
                                }
                            }
                        case .failure(_):
                            print("Loading error nos posts da sala \(sala.nome)!")
                            sala.loadingPostsError = true
                    }
                }
            }
        }
        
        
        DispatchQueue.global().async {
            // DispatchQueue.global por que senao o app congela enquanto baixa as salas
            while true {
                // Espera pra retornar a sala quando carrega membros e categs
                if sala.membros.count == membrosRef.count && sala.categorias.count == categsRef.count && !loadingError {
                    
                    sala.regraDoAdmin()
                    
                    print("Retornando sala \(sala.nome)!")
                    DispatchQueue.main.async {
                        completion(sala)
                    }
                    break
                }
                sleep(1)
                /*
                 Sem esse sleep os fetches de membro, categ e post
                 comecam mas nao terminam e o app nao fica esperando
                 para todo o sempre !!!
                */
            }
        }
    }
    
    func ckLoadAllPosts() {
        print("Baixando posts da sala \(nome)")
        tentouBaixarPosts = true
        for postRef in postsRef {
            Post.ckLoad(from: postRef, salaMembros: membros) { (result) in
                switch result {
                    case .success(let loadedPost):
                        if let loadedPost = loadedPost {
                            DispatchQueue.main.async {
                                self.posts.append(loadedPost)
                                loadedPost.ckLoadAllPerguntas(sala: self)
                                loadedPost.ckLoadAllComentarios(sala: self)
                                self.allPostsLoaded = (self.posts.count == self.postsRef.count)
                            }
                        }
                    case .failure(_):
                        print("Loading error nos posts da sala \(self.nome)!")
                        self.loadingPostsError = true
                }
            }
        }
    }
    
}
