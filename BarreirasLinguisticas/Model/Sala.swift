//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation
import CloudKitMagicCRUD

class Sala: Identifiable, ObservableObject, CKMRecord {
    var recordName: String?
    var id: String = ""
    @Published var nome: String = ""
    @Published var membros: [Membro] = []
    @Published var posts: [Post] = []
    @Published var categorias: [Categoria] = []
    
    init(id: String, nome: String) {
        self.id = id
        self.nome = nome
    }
    
    func encode(to encoder: Encoder) throws {
    }
    required init(from decoder: Decoder) throws {
        print("required init Sala")
    }
    
    //MARK: - FUNCOES GET
    func getMembro(id: String?) -> Membro? {
        for membro in self.membros {
            if (id == membro.usuario.id) { return membro }
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
    
    func getIdsCategorias(ids: [String]) -> [String] {
        var categorias: [String] = []
        for id in ids {
            for categ in self.categorias {
                if (id == categ.id) { categorias.append(categ.id!) }
            }
        }
        return categorias
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
        if getMembro(id: usuario.id) == nil { //para nao adicionar membro repetido
            let membro = Membro(usuario: usuario, idSala: self.id, is_admin: is_admin)
            self.membros.append(membro)
        }
    }
    
    func getNovoMembro(id id_membro: String?, usuario: Usuario, is_admin: Bool) -> Membro? {
        if getMembro(id: usuario.id) == nil { //para nao adicionar membro repetido
            let membro = Membro(usuario: usuario, idSala: self.id, is_admin: is_admin)
            return membro
        }
        return nil
    }
    
    func novoAdmin(membro: Membro) {
        membro.is_admin = true
    }
    
    func novaCategoria(_ categoria: Categoria) {
        self.categorias.append(categoria)
    }

    func novoPost(publicador id_membro: String?, post id_post: Int, titulo: String, descricao: String?, link: Link?, categs: [String], tags: String) {
        let membro = getMembro(id: id_membro)
//        let idsCategorias = getIdsCategorias(ids: categs)
//        let categorias = getCategorias(ids: idsCategorias)
        
        if membro != nil {
//            if idsCategorias.count != 0 {
            if categs.count != 0 {
                let post = Post(titulo: titulo, descricao: descricao, link: link, categs: categs, tags: tags, publicador: membro!)
                
                self.posts.append(post)
                membro?.publicaPost(post: post.id)
                for categ in categorias {
                    categ.addPostTags(post: post)
                }
            }
            else {
                print("Sala novoPost: Impossível criar o post pois nenhuma categoria é válida")
            }
        }
        else {
            print("Sala novoPost: Impossível criar o post pois o membro publicador não existe")
        }
        
    }
    
    func excluiPost(id_post: String){
        posts.removeAll(where: { $0.id == id_post})
    }
    
    //MARK: - RELACIONAMENTOS
    func novoComentario(id: Int, publicador id_publicador: String?, post id_post: String, conteudo: String, is_question: Bool) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post)  {
            post.novoComentario(publicador: publicador, conteudo: conteudo, is_question: is_question)
        }
        else {
            print("Comentário não adicionado por publicador não identificado")
        }
    }
    
    func novoReply(id: Int, publicador id_publicador: String?, post id_post: String, conteudo: String, original id_original: String) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post) {
            post.novoReply(publicador: publicador, conteudo: conteudo, original: id_original)
        }
        else {
            print("Comentário não adicionado por publicador ou post não identificado")
        }
    }
    
    func novaAssinatura(membro id_membro: String?, categoria: String) {
        let membro = getMembro(id: id_membro)
        let categ = getCategoria(id: categoria)
        
        membro?.assinaCategoria(categoria: categ?.id)
//        categ?.addAssinantes(membro: membro)
    }
    
    func salvaPost(membro id_membro: String, post id_post: String) {
        let membro = getMembro(id: id_membro)
        let post = getPost(id: id_post)
        
        membro?.salvaPost(post: post?.id)
    }
    
    func removeMembro(membro id_membro: String) {
        self.membros.removeAll(where: {$0.usuario.id == id_membro})
    }
    
}
