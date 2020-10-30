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
    var id: String {self.recordName ?? String(self.hashValue)}
    @Published var nome: String
    @Published var membros: [Membro] = []
    @Published var posts: [Post] = []
    @Published var categorias: [Categoria] = []
    
    init(nome: String, criador: Usuario/*, dao: DAO*/) {
        self.nome = nome
        novoMembro(id: criador.id, usuario: criador, is_admin: true)
    } // init()
    
    //MARK: - FUNCOES GET
    func getMembro(id: String?) -> Membro? {
        for membro in self.membros {
            if (id == membro.usuario.id) { return membro }
        }
        return nil
    }
    
    func getCategoria(id: Int) -> Categoria? {
        for categ in self.categorias {
            if (id == categ.id) { return categ }
        }
        return nil
    }
    
    func getCategorias(ids: [Int]) -> [Categoria] {
        var categorias: [Categoria] = []
        for id in ids {
            for categ in self.categorias {
                if (id == categ.id) { categorias.append(categ) }
            }
        }
        return categorias
    }
    
    func getPost(id: Int) -> Post? {
        for post in self.posts {
            if (id == post.id) { return post }
        }
        return nil
    }
    
    func getPostsByCategorie(categ: Int) -> [Post] {
        var posts: [Post] = []
        
        for post in self.posts {
            for cat in post.categorias {
                if cat.id == categ {
                    posts.append(post)
                }
            }
        }
        
        return posts
    }
    
    //MARK: - NOVOS OBJETOS
    
    func novoMembro(id id_membro: String?, usuario: Usuario, is_admin: Bool) {
            if getMembro(id: usuario.id) == nil { //para nao adicionar membro repetido
                let membro = Membro(usuario: usuario, sala: self, is_admin: is_admin)
                self.membros.append(membro)
            }
    }
    
    func novoAdmin(membro: Membro) {
        membro.is_admin = true
    }
    
    func novaCategoria(id: Int, nome: String) {
        self.categorias.append(Categoria(id: id, nome: nome))
    }

    func novoPost(publicador id_membro: String?, post id_post: Int, titulo: String, descricao: String?, link: Link?, categs: [Int], tags: String) {
        let membro = getMembro(id: id_membro)
        let categorias = getCategorias(ids: categs)
        
        if membro != nil {
            if categorias.count != 0 {
                let post = Post(id: id_post, titulo: titulo, descricao: descricao, link: link, categs: categorias, tags: tags, publicador: membro!)
                
                self.posts.append(post)
                membro?.publicaPost(post: post)
                for categ in categorias {
                    categ.addPost(post: post)
                }
            }
            else {
                print("Impossível criar o post pois nenhuma categoria é válida")
            }
        }
        else {
            print("Impossível criar o post pois o membro publicador não existe")
        }
        
    }
    
    func excluiPost(id_post: Int){
        posts.removeAll(where: { $0.id == id_post})
    }
    
    //MARK: - RELACIONAMENTOS
    func novoComentario(id: Int, publicador id_publicador: String?, post id_post: Int, conteudo: String, is_question: Bool) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post)  {
            post.novoComentario(id: id, publicador: publicador, conteudo: conteudo, is_question: is_question)
        }
        else {
            print("Comentário não adicionado por publicador não identificado")
        }
    }
    
    func novoReply(id: Int, publicador id_publicador: String?, post id_post: Int, conteudo: String, original id_original: Int) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post) {
            post.novoReply(id: id, publicador: publicador, conteudo: conteudo, original: id_original)
        }
        else {
            print("Comentário não adicionado por publicador ou post não identificado")
        }
    }
    
    func novaAssinatura(membro id_membro: String?, categoria: Int) {
        let membro = getMembro(id: id_membro)
        let categ = getCategoria(id: categoria)
        
        membro?.assinaCategoria(categoria: categ)
        categ?.addAssinantes(membro: membro)
    }
    
    func salvaPost(membro id_membro: String, post id_post: Int) {
        let membro = getMembro(id: id_membro)
        let post = getPost(id: id_post)
        
        membro?.salvaPost(post: post)
    }
    
    func removeMembro(membro id_membro: String) {
        self.membros.removeAll(where: {$0.usuario.id == id_membro})
    }
}
