//
//  CKManager.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI
import UIKit

struct CKManager {
    
    private static func getUserFromDictionary(_ userDictionaryOpt: Dictionary<String, Any>?) -> Usuario? {
        if let usuarioDictionary = userDictionaryOpt {
            let id = usuarioDictionary["recordName"] as! String
            let nome = usuarioDictionary["nome"] as? String
            let foto = UIImage(named: "perfil")!
            let fluencia = Usuario.pegaFluencia(
                nome: usuarioDictionary["fluencia_ingles"] as! String)
            
            let usuario = Usuario(
                nome: nome,
                foto_perfil: foto,
                fluencia_ingles: fluencia
            )
            usuario.id = id
            
            return usuario
        } else {
            print(#function)
            print("usuarioDictionary is nil")
        }
        return nil
    }
    
    private static func getMembroFromDictionary(_ membroDictionaryOpt: Dictionary<String, Any>?) -> Membro? {
        if let membroDictionary = membroDictionaryOpt {
            let usuario = getUserFromDictionary( membroDictionary["usuario"]! as? Dictionary<String,Any>)
            
            let recordName = membroDictionary["recordName"] as! String
            let idSala = membroDictionary["idSala"] as! String
            let admin = membroDictionary["is_admin"] as! Int
            let is_admin: Bool
            if admin == 1 { is_admin = true }
                else { is_admin = false }
            
            let membro = Membro(usuario: usuario!, idSala: idSala, is_admin: is_admin)
            membro.id = recordName
            return membro
        
        } else {
            print(#function)
            print("membroDictionary is nil")
        }
        return nil
    }
    
    private static func getCategoriaFromDictionary(_ categDictionaryOpt:Dictionary<String, Any>?) -> Categoria? {
        
        if let categDictionary = categDictionaryOpt {
            let id = categDictionary["recordName"] as! String
            let nome = categDictionary["nome"] as! String
            let tagsPosts = categDictionary["tagsPosts"] as? [String] ?? []
            
            let categoria = Categoria(nome: nome)
            categoria.id = id
            categoria.tagsPosts = tagsPosts
            return categoria
            
        } else {
            print(#function)
            print("categDictionary is nil")
            return nil
        }
    }
    
    private static func getComentarioFromDictionary(_ comentarioDictionaryOpt:Dictionary<String, Any>?, with membros: [Membro]) -> Comentario?  {
        if let comentarioDictionary = comentarioDictionaryOpt{
            let recordName = comentarioDictionary["recordName"] as! String
            let conteudo = comentarioDictionary["conteudo"] as! String
            let post = comentarioDictionary["post"] as! String
            let id_publicador = comentarioDictionary["id_publicador"] as! String
            let is_question = comentarioDictionary["is_question"] as! Int == 1 ? true : false
            
            let publicador = membros.filter({$0.id == id_publicador})
            
            let comentario = Comentario(
                post: post,
                publicador: publicador[0],
                conteudo: conteudo,
                is_question: is_question
            )
            comentario.id = recordName
            return comentario
        }
        return nil
    }
    
    private static func getPostFromDictionary(_ postDictionaryOpt:Dictionary<String, Any>?, with membros: [Membro]) -> Post? {
        if let postDictionary = postDictionaryOpt {
            /*
             @Published var denuncias: [String] = []
             */
            if let publicador = getMembroFromDictionary(postDictionary["publicador"] as? Dictionary<String, Any>) {
                // Atributos gerais do post
                let id = postDictionary["recordName"] as! String
                let titulo = postDictionary["titulo"] as! String
                let descricao = postDictionary["descricao"] as! String
                let categs = postDictionary["categorias"] as! [String]
                let tags = postDictionary["tags"] as? [String]
                
                // Atributos do link do post
                let idLink = postDictionary["idLink"] as? Int
                let titleLink = postDictionary["titleLink"] as? String
                let urlLink = postDictionary["urlLink"] as? String
                let newLink = LinkPost()
                newLink.id = idLink
                newLink.title = titleLink
                newLink.url = urlLink
                // faltando a imagem
                
                // Perguntas e comentarios
                var comentarios: [Comentario] = []
                let comentariosDicts = postDictionary["comentarios"] as! Array<Dictionary<String,Any>>
                for comentarioDict in comentariosDicts {
                    if let comentario = getComentarioFromDictionary(comentarioDict, with: membros) {
                        comentarios.append(comentario)
                    }
                }
                
                var perguntas: [Comentario] = []
                let perguntasDicts = postDictionary["perguntas"] as! Array<Dictionary<String,Any>>
                for perguntaDict in perguntasDicts {
                    if let pergunta = getComentarioFromDictionary(perguntaDict, with: membros) {
                        perguntas.append(pergunta)
                    }
                }
                
                // Montagem do post
                let post = Post(
                    titulo: titulo,
                    descricao: descricao,
                    link: newLink,
                    categs: categs,
                    tags: "",
                    publicador: publicador
                )
                post.tags = tags ?? []
                post.perguntas = perguntas
                post.comentarios = comentarios
                post.id = id
                return post
                
            }
            return nil
        }
        return nil
    }
    
    static func deleteRecord(recordName: String, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: CKRecord.ID(recordName: recordName)) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                if let recordID = recordID {
                    completion(.success(recordID))
                }
            }
        }
    } // delete
    
}

// MARK: - USUARIO
extension CKManager {
    static func saveUsuario(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()) {
        let userRecord = CKRecord(recordType: "Users")
        userRecord["nome"] = user.nome as CKRecordValue
        userRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
        
        // FALTA A FOTO DE PERFIL
        
        CKContainer.default().publicCloudDatabase.save(userRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                
                if let record = record {
                    let id = record.recordID.recordName
                    guard let nome = record["nome"] as? String else {
                        print("saveUser: problema ao baixar o nome")
                        return
                    }
//                    guard let foto = record["foto_perfil"] as? UIImage else {
//                        print("saveUser: problema ao baixar a foto")
//                        return
//                    }
                    guard let fluencia = record["fluencia_ingles"] as? String else {
                        print("saveUser: problema ao baixar a fluencia")
                        return
                    }
                    
                    let savedUser = Usuario(
                        nome: nome,
                        foto_perfil: UIImage(named: "perfil")!,
                        fluencia_ingles: Usuario.pegaFluencia(nome: fluencia))
                    savedUser.id = id
                    
                    completion(.success(savedUser))
                }
            }
        }
    }
    
    static func fetchUsuario(recordName: String, completion: @escaping (Result<Usuario, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let record = record {
                // SEM GUARD LET POR CONTA DA CRIACAO DE UM NOVO USUARIO
                let id = record.recordID.recordName
                let nome = record["nome"] as? String
//                guard let nome = record["nome"] as? String else {
//                    print("fetchUser: problema ao baixar o nome")
//                    return
//                }
//                guard let foto = record["foto_perfil"] as? UIImage else {
//                    print("fetchUser: problema ao baixar a foto")
//                    return
//                }
                let fluencia = record["fluencia_ingles"] as? String
//                guard let fluencia = record["fluencia_ingles"] as? String else {
//                    print("fetchUser: problema ao baixar a fluencia")
//                    return
//                }
                let sala_atual = record["sala_atual"] as? String 
//                let sala_atual = record["sala_atual"] as? Sala
                
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: UIImage(named: "perfil")!,
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? ""))
                fetchedUser.id = id
                fetchedUser.sala_atual = sala_atual
                
                completion(.success(fetchedUser))
            }
        }
    }
    
    static func modifyUsuario(user: Usuario, completion: @escaping (Result<Usuario, Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: user.id)){ (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedRecord = record {
                fetchedRecord["nome"] = user.nome as CKRecordValue
                fetchedRecord["fluencia_ingles"] = user.fluencia_ingles as CKRecordValue
                fetchedRecord["sala_atual"] = (user.sala_atual ?? "") as CKRecordValue
                // FALTA A FOTO DE PERFIL !!!
                
                publicDB.save(fetchedRecord) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedRecord = record {
                        guard let nome = savedRecord["nome"] as? String else {
                            print("updateUser: problema ao baixar o nome")
                            return
                        }
//                        guard let foto = savedRecord["foto_perfil"] as? UIImage else {
//                            print("updateUser: problema ao baixar a foto")
//                            return
//                        }
                        guard let fluencia = savedRecord["fluencia_ingles"] as? String else {
                            print("updateUser: problema ao baixar a fluencia")
                            return
                        }
                        var sala_atual = savedRecord["sala_atual"] as? String
                        if sala_atual == "" { sala_atual = nil }
                        
                        let savedUser = Usuario(
                            nome: nome,
                            foto_perfil: UIImage(named: "perfil")!,
                            fluencia_ingles: Usuario.pegaFluencia(nome: fluencia)
                        )
                        savedUser.id = user.id
                        savedUser.sala_atual = sala_atual
                        
                        completion(.success(savedUser))
                    }
                }
            }
        }
        
    }
    
}

// MARK: - SALA
extension CKManager {
    static func loadSalasRecords(completion: @escaping (Result<[CKRecord], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        let querySalas = CKQuery(recordType: "Sala", predicate: NSPredicate(value: true))
        publicDB.perform(querySalas, inZoneWith: nil) { (records, error) in
            if let  error = error {
                print(#function)
                print("Erro ao carregar salas")
                completion(.failure(error))
            }
            if let loadedSalas = records {
                completion(.success(loadedSalas))
            }
        }
    } // funcao
    
    static func getSalaFromRecord(salaRecord: CKRecord) -> Sala? {
        // RECORD NAME
        guard let salaRecordName = salaRecord.asDictionary["recordName"] as? String else {
            print(#function)
            print("Erro ao capturar o recordName de uma sala")
            return nil
        }
        // NOME
        guard let salaNome = salaRecord.asDictionary["nome"] as? String else {
            print(#function)
            print("Erro ao capturar o nome de uma sala")
            return nil
        }
        // MEMBROS
        guard let membrosDictionaries = salaRecord.asDictionary["membros"] as? Array<Optional<Dictionary<String, Any>>> else {
            print(#function)
            print("Erro no cast do vetor de membros")
            return nil
        }
        var membros: [Membro] = []
        for membroDictionary in membrosDictionaries {
            if let membro = getMembroFromDictionary(membroDictionary) {
                membros.append(membro)
            } else {
                print(#function)
                print("Nao adquiriu membro do dicionario!")
            }
        }
        
        // CATEGORIAS
        var categorias: [Categoria] = []
        if let categoriasDictionaries = salaRecord.asDictionary["categorias"] as? Array<Optional<Dictionary<String, Any>>> {
            
            for categoriaDictionary in categoriasDictionaries {
                if let categ = getCategoriaFromDictionary(categoriaDictionary) {
                    categorias.append(categ)
                } else {
                    print(#function)
                    print("Nao adquiriu categoria do dicionario!")
                }
            }
        }
        
        // POSTS
        var posts: [Post] = []
        if let postsDictionaries = salaRecord.asDictionary["posts"] as? Array<Optional<Dictionary<String, Any>>> {

            for postDictionary in postsDictionaries {
                if let post = getPostFromDictionary(postDictionary, with: membros) {
                    posts.append(post)
                } else {
                    print(#function)
                    print("Nao adquiriu post do dicionario!")
                }
            }
        }
        
        let sala = Sala(id: salaRecordName, nome: salaNome)
        sala.membros.append(contentsOf: membros)
        sala.categorias.append(contentsOf: categorias)
        sala.posts.append(contentsOf: posts)
        return sala
    }
    
    static func saveSala(nome: String, completion: @escaping (Result<Sala, Error>) -> ()) {
        let salaRecord = CKRecord(recordType: "Sala")
        salaRecord["nome"] = nome
        
        CKContainer.default().publicCloudDatabase.save(salaRecord){ (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao salvar sala no publicDB")
                completion(.failure(error))
                return
            }
            if let savedRecord = record {
                guard let nome = savedRecord["nome"] as? String else {
                    print(#function)
                    print("Problema ao baixar o nome")
                    return
                }
                
                let sala = Sala(id: savedRecord.recordID.recordName, nome: nome)
                completion(.success(sala))
            }
        }
    }
    
    static func modifySalaMembros(sala: Sala, completion: @escaping (Result<[CKRecord.Reference], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            // BUSCA PELA SALA
            if let error = error {
                print(#function)
                print("Erro ao buscar sala")
                completion(.failure(error))
                return
            }
            if let fetchedSala = record {
                // PREPARA OS DADOS
                var membros_array: [CKRecord.Reference] = []
                for m in sala.membros {
                    membros_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: m.id), action: .deleteSelf))
                }
                fetchedSala["membros"] = membros_array
                
                // ATUALIZA
                publicDB.save(fetchedSala) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedRecord = record {
                        guard let membrosReferences = savedRecord["membros"] as? [CKRecord.Reference] else {
                            print(#function)
                            print("Problema ao baixar os membros")
                            return
                        }
                        completion(.success(membrosReferences))
                    }
                }
            }
        }
    }
    
    static func modifySalaCategorias(sala: Sala, completion: @escaping (Result<[CKRecord.Reference], Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            // BUSCA PELA SALA
            if let error = error {
                print(#function)
                print("Erro ao buscar sala")
                completion(.failure(error))
                return
            }
            if let fetchedSala = record {
                var categorias_array: [CKRecord.Reference] = []
                for categ in sala.categorias {
                    categorias_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: categ.id), action: .deleteSelf))
                }
                fetchedSala["categorias"] = categorias_array
                
                publicDB.save(fetchedSala) { (record, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let savedSalaRecord = record {
                        guard let categoriasReferences = savedSalaRecord["categorias"] as? [CKRecord.Reference] else {
                            print(#function)
                            print("Problema ao baixar as categorias")
                            return
                        }
                        completion(.success(categoriasReferences))
                    }
                }
            }
        }
    }
    
    static func modifySalaPosts(sala: Sala, completion: @escaping (Result<[CKRecord.Reference], Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao buscar sala")
                completion(.failure(error))
                return
            }
            if let fetchedSalaRecord = record {
                var posts_array: [CKRecord.Reference] = []
                for post in sala.posts {
                    posts_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: post.id), action: .none))
                }
                fetchedSalaRecord["posts"] = posts_array
                publicDB.save(fetchedSalaRecord) { (record2, error2) in
                    if let error2 = error2 {
                        completion(.failure(error2))
                        return
                    }
                    if let savedSalaRecord = record {
                        guard let postsReferences = savedSalaRecord["posts"] as? [CKRecord.Reference] else {
                            print(#function)
                            print("Problema ao baixar os posts")
                            return
                        }
                        completion(.success(postsReferences))
                    }
                }
            }
        }
    }
}

// MARK: - MEMBRO
extension CKManager {
    static func saveMembro(membro: Membro, completion: @escaping (Result<Membro, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let membroRecord = CKRecord(recordType: "Membro")
        membroRecord["usuario"] = CKRecord.Reference(
            recordID: CKRecord.ID(recordName: membro.usuario.id), action: .deleteSelf
        )
        membroRecord["idSala"] = membro.idSala
        membroRecord["is_admin"] = membro.is_admin ? 1 : 0
        
        // MANDANDO SALVAR
        CKContainer.default().publicCloudDatabase.save(membroRecord) { (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao salvar membro")
                completion(.failure(error))
            }
            
            // RECEBENDO OS DADOS SALVOS
            if let savedMembro = record {
                if let userReference = savedMembro["usuario"] as? CKRecord.Reference {
                    fetchUsuario(recordName: userReference.recordID.recordName) { (result) in
                        switch result {
                            case .success(let fetchedUser):
                                DispatchQueue.main.async {
                                    guard let idSala = savedMembro["idSala"] as? String else {
                                        print(#function)
                                        print("Problema ao baixar a idSala do membro")
                                        return
                                    }
                                    guard let admin = savedMembro["is_admin"] as? Int else {
                                        print(#function)
                                        print("Problema ao baixar o is_admin do membro")
                                        return
                                    }
                                    
                                    let is_admin: Bool
                                    if admin == 1 { is_admin = true}
                                    else { is_admin = false }
                                    
                                    let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                    membro.id = savedMembro.recordID.recordName
                                    completion(.success(membro))
                                }
                            case .failure(let error):
                                print(#function)
                                print("fetchUser")
                                print(error)
                        }
                    }
                }
            }
        } // .save

    } // funcao
    
    static func fetchMembro(recordName: String, completion: @escaping (Result<Membro, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedMembro = record {
                if let usuarioReference = fetchedMembro["usuario"] as? CKRecord.Reference {
                    fetchUsuario(recordName: usuarioReference.recordID.recordName) { (result) in
                        switch result {
                            case .success(let fetchedUser):
                                guard let idSala = fetchedMembro["idSala"] as? String else {
                                    print("saveMembro: Problema ao baixar a idSala do membro")
                                    return
                                }
                                guard let admin = fetchedMembro["is_admin"] as? Int else {
                                    print("saveMembro: Problema ao baixar o is_admin do membro")
                                    return
                                }
                                let is_admin: Bool
                                if admin == 1 { is_admin = true}
                                else { is_admin = false }
                                
                                let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                membro.id = fetchedMembro.recordID.recordName
                                completion(.success(membro))
                            case .failure(let error):
                                print(#function)
                                print(error)
                        }
                    }
                }
            }
        }
    } //fetchMembro
    
    static func modifyMembroPublicados(membro: Membro, completion: @escaping (Result<[String], Error>) -> ()) {
        
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: membro.id)) { (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao buscar membro")
                completion(.failure(error))
                return
            }
            if let fetchedMembroRecord = record {
                fetchedMembroRecord["posts_publicados"] = membro.posts_publicados
                publicDB.save(fetchedMembroRecord) { (record2, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print("Erro ao salvar membro")
                        completion(.failure(error2))
                        return
                    }
                    if let savedMembroRecord = record2 {
                        guard let publicados = savedMembroRecord["posts_publicados"] as? [String] else {
                            print("Nao pode baixar posts publicados")
                            return
                        }
                        completion(.success(publicados))
                    }
                }
            }
        }
    }
}

// MARK: - CATEGORIA
extension CKManager {
    static func saveCategoria(categoria: Categoria, completion: @escaping (Result<Categoria, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let categoriaRecord = CKRecord(recordType: "Categoria")
        categoriaRecord["nome"] = categoria.nome
        
        // SALVANDO NO BANCO
        CKContainer.default().publicCloudDatabase.save(categoriaRecord){ (record,error) in
            if let error = error {
                print(#function)
                print("Erro ao salvar categoria")
                completion(.failure(error))
            }
            if let savedCategRecord = record {
                guard let nome = savedCategRecord["nome"] as? String else {
                    print(#function)
                    print("Problema ao baixar o nome")
                    return
                }
                
                let categoria = Categoria(nome: nome)
                categoria.id = savedCategRecord.recordID.recordName
                completion(.success(categoria))
            }
            
        }
    }
    
    static func modifyCategoriaTagsPosts(categoria: Categoria, completion: @escaping (Result<[String], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: categoria.id)){ (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao buscar categoria")
                completion(.failure(error))
                return
            }
            if let fetchedCateg = record {
                fetchedCateg["tagsPosts"] = categoria.tagsPosts
                publicDB.save(fetchedCateg) { (record2, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print("Erro ao salvar categoria")
                        completion(.failure(error2))
                        return
                    }
                    if let savedCategRecord = record2 {
                        let tagsPosts = savedCategRecord["tagsPosts"] as? [String] ?? []
                        completion(.success(tagsPosts))
                    }
                }
            }
        }
    }
}

//MARK: - POST
extension CKManager {
    static func savePost(post: Post, completion: @escaping (Result<Post, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let postRecord = CKRecord(recordType: "Post")
        postRecord["titulo"] = post.titulo
        postRecord["descricao"] = post.descricao
        postRecord["idLink"] = post.link?.id
        postRecord["titleLink"] = post.link?.title
        postRecord["urlLink"] = post.link?.url
        postRecord["publicador"] = CKRecord.Reference(
            recordID: CKRecord.ID(recordName: post.publicador.id), action: .deleteSelf
        )
        postRecord["categorias"] = post.categorias
        postRecord["tags"] = post.tags
        
        // SALVANDO NO BANCO
        CKContainer.default().publicCloudDatabase.save(postRecord){ (record,error) in
            if let error = error {
                print(#function)
                print("Erro ao salvar post")
                completion(.failure(error))
            }
            if let savedPostRecord = record {
                let titulo = savedPostRecord["titulo"] as? String
                let desc = savedPostRecord["descricao"] as? String
//                let idLink = savedPostRecord["idLink"] as? Int
                guard let categs = savedPostRecord["categorias"] as? [String] else {
                    print(#function)
                    print("Problema ao baixar categorias")
                    return
                }
                let tags = savedPostRecord["tags"] as? [String]
                guard let publicador = savedPostRecord["publicador"] as? CKRecord.Reference else {
                    print(#function)
                    print("Problema ao baixar publicador")
                    return
                }
                fetchMembro(recordName: publicador.recordID.recordName) { (result) in
                    switch result {
                        case .success(let fetchedMembro):
                            DispatchQueue.main.async {
                                let newPost  = Post(
                                    titulo: titulo,
                                    descricao: desc,
                                    link: post.link,
                                    categs: categs,
                                    tags: "",
                                    publicador: fetchedMembro
                                )
                                newPost.tags = tags ?? []
                                post.id = savedPostRecord.recordID.recordName
                                completion(.success(post))
                            }
                        case .failure(let error2):
                            print(#function)
                            print(error2)
                    }
                }
            }
        }
    }
    
    static func modifyPostComentarios(post: Post, completion: @escaping (Result<String, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: post.id)) { (fetchedRecord, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let fetchedPostRecord = fetchedRecord {
                var perguntas: [CKRecord.Reference] = []
                for pergunta in post.perguntas {
                    perguntas.append(
                        CKRecord.Reference(
                                        recordID: CKRecord.ID(recordName: pergunta.id),
                                        action: .none
                        )
                    )
                }
                fetchedPostRecord["perguntas"] = perguntas
                
                var comentarios: [CKRecord.Reference] = []
                for comentario in post.comentarios {
                    comentarios.append(
                        CKRecord.Reference(
                            recordID: CKRecord.ID(recordName: comentario.id),
                            action: .none)
                    )
                }
                fetchedPostRecord["comentarios"] = comentarios
                
                publicDB.save(fetchedPostRecord) { (savedRecord, error2) in
                    if let error2 = error2 {
                        completion(.failure(error2))
                        return
                    }
                    if let savedPostRecord = savedRecord {
                        completion(.success(savedPostRecord.recordID.recordName))
                        return
                    }
                }
            }
        }
    }
}

//MARK: - COMENTARIO
extension CKManager {
    static func saveComentario(comentario: Comentario, completion: @escaping (Result<String, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let comentarioRecord = CKRecord(recordType: "Comentario")
        comentarioRecord["post"] = comentario.post
        comentarioRecord["id_publicador"] = comentario.publicador.id
            //CKRecord.Reference(recordID: CKRecord.ID(recordName: comentario.publicador.id), action: .none) // ou action: .none ????
        comentarioRecord["conteudo"] = comentario.conteudo
        comentarioRecord["is_question"] = comentario.is_question ? 1 : 0

        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.save(comentarioRecord) { (savedRecord, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let comentarioRecord = savedRecord {
                let recordName = comentarioRecord.recordID.recordName
                completion(.success(recordName))
                return
            }
        }
    }
}
