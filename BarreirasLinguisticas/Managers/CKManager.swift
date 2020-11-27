//
//  CKManager.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKit

struct CKManager {
    static func deleteRecordCompletion(recordName: String, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
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
    }
    
    static func deleteRecord(recordName: String) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.delete(withRecordID: CKRecord.ID(recordName: recordName)) { (recordID, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if recordID != nil {
                print("Deletion success!")
                return
            }
        }
    }
    
}

// MARK: - SALA
extension CKManager {
    static func loadRecordsDasSalas(completion: @escaping (Result<[CKRecord], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        let querySalas = CKQuery(recordType: "Sala", predicate: NSPredicate(value: true))
        publicDB.perform(querySalas, inZoneWith: nil) { (records, error) in
            if let  error = error {
                print(#function)
                completion(.failure(error))
            }
            if let loadedSalas = records {
                print("Records das salas carregados com sucesso")
                completion(.success(loadedSalas))
            }
        }
    } // funcao
    
    static func getSalaFromRecord(_ salaRecord: CKRecord) -> Sala? {
        print("Entrou em \(#function)")
        let salaRecordAsDictionary = salaRecord.asDictionary
        
        // RECORD NAME
        print("Getting salaRecordName...")
        guard let salaRecordName = salaRecordAsDictionary["recordName"] as? String else {
            print("\(#function) - Erro ao capturar o recordName de uma sala")
            return nil
        }
        
        // NOME
        print("Getting salaNome...")
        guard let salaNome = salaRecordAsDictionary["nome"] as? String else {
            print("\(#function) - Erro ao capturar o nome de uma sala")
            return nil
        }
        print("Noma da sala: \(salaNome)")
        
        // MEMBROS
        print("Getting membrosDictionaries...")
        var membros: [Membro] = []
        var countMembros = 0
        if let membrosDictionaries = salaRecord.asDictionary["membros"] as? Array<Optional<Dictionary<String, Any>>> {
            for membroDictionary in membrosDictionaries {
                countMembros += 1
                if let membro = getMembroFromDictionary(membroDictionary) {
                    membros.append(membro)
                } else {
                    print("\t\(#function) - Nao adquiriu membro \(countMembros) do dicionario!")
                }
            }
        } else {
            print("\(#function) - Erro no cast do vetor de membros")
            return nil
        }

        
        // CATEGORIAS
        print("Getting categoriasDictionaries...")
        var categorias: [Categoria] = []
        var countCategorias = 0
        if let categoriasDictionaries = salaRecord.asDictionary["categorias"] as? Array<Optional<Dictionary<String, Any>>> {
            for categoriaDictionary in categoriasDictionaries {
                countCategorias += 1
                if let categ = getCategoriaFromDictionary(categoriaDictionary) {
                    categorias.append(categ)
                } else {
                    print("\t\(#function) - Nao adquiriu categoria \(countCategorias) do dicionario!")
                }
            }
        } else {
            print("\(#function) - Erro no cast do vetor de categorias")
            return nil
        }
        
        // POSTS
        print("Getting postsDictionaries...")
        var posts: [Post] = []
        var countPosts = 0
        if let postsDictionaries = salaRecord.asDictionary["posts"] as? Array<Optional<Dictionary<String, Any>>> {
            for postDictionary in postsDictionaries {
                countPosts += 1
                if let post = getPostFromDictionary(postDictionary, with: membros) {
                    posts.append(post)
                } else {
                    print("\t\(#function) - Nao adquiriu post \(countPosts) do dicionario!")
                }
            }
        } else {
            print("\(#function) - Erro no cast do vetor de posts")
            return nil
        }
        
        // SALA
        let sala = Sala(id: salaRecordName, nome: salaNome)
        sala.membros.append(contentsOf: membros)
        sala.categorias.append(contentsOf: categorias)
        sala.posts.append(contentsOf: posts)
        print("Returning sala \(salaNome)\n")
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
    
    static func modifySala(_ sala: Sala){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedSala = record {
                // MEMBROS
                var membros_array: [CKRecord.Reference] = []
                for m in sala.membros {
                    membros_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: m.id), action: .none))
                }
                fetchedSala["membros"] = membros_array
                
                // CATEGORIAS
                var categorias_array: [CKRecord.Reference] = []
                for categ in sala.categorias {
                    categorias_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: categ.id), action: .none))
                }
                fetchedSala["categorias"] = categorias_array
                
                //POSTS
                var posts_array: [CKRecord.Reference] = []
                for post in sala.posts {
                    posts_array.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: post.id), action: .none))
                }
                fetchedSala["posts"] = posts_array
                
                publicDB.save(fetchedSala) { (record, error2) in
                    if let error2 = error2 {
                        print(error2)
                        return
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

// MARK: - USUARIO
extension CKManager {
    static func fetchUsuario(recordName: String, completion: @escaping (Result<Usuario, Error>) -> ()) {
        print("Entrou em \(#function)")
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
                let fluencia = record["fluencia_ingles"] as? String
                let sala_atual = record["sala_atual"] as? String
                
                var foto: Data? = nil
                let fotoData = FileSystem.retrieveImage(forId: id)
                let fotoAsset = record["url_foto"] as? CKAsset
                
                if fotoData != nil { // Primeiro busca no disco
                    foto = fotoData
                } else if fotoAsset != nil { // Depois busca no CK
                    foto = NSData(contentsOf: fotoAsset!.fileURL!) as Data?
                }
                
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: foto,
                    fluencia_ingles: Usuario.pegaFluencia(nome: fluencia ?? "")
                )
                fetchedUser.id = id
                fetchedUser.sala_atual = sala_atual
                
                completion(.success(fetchedUser))
            }
        }
    }
    
    static func modifyUsuario(user: Usuario){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: user.id)){ (record, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedRecord = record {
                fetchedRecord["nome"] = user.nome
                fetchedRecord["fluencia_ingles"] = user.fluencia_ingles
                fetchedRecord["sala_atual"] = (user.sala_atual ?? "")
                if let url = user.url_foto {
                    fetchedRecord["foto_perfil"] = CKAsset(fileURL: url)
                }
                
                publicDB.save(fetchedRecord) { (record, error) in
                    if let error = error {
                        print(#function)
                        print(error)
                        return
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
        membroRecord["is_admin"] = membro.isAdmin ? 1 : 0
        membroRecord["isBlocked"] = membro.isBlocked ? 1 : 0
        
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
                                    
                                    guard let blocked = savedMembro["isBlocked"] as? Int else {
                                        print(#function)
                                        print("Problema ao baixar o isBlocked do membro")
                                        return
                                    }
                                    
                                    let is_admin: Bool
                                    if admin == 1 { is_admin = true}
                                        else { is_admin = false }
                                    
                                    let is_blocked: Bool
                                    if blocked == 1 { is_blocked = true}
                                        else { is_blocked = false }
                                    
                                    let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                    membro.isBlocked = is_blocked
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
                                    print(#function)
                                    print("Problema ao baixar a idSala do membro")
                                    return
                                }
                                guard let admin = fetchedMembro["is_admin"] as? Int else {
                                    print(#function)
                                    print("Problema ao baixar o is_admin do membro")
                                    return
                                }
                                guard let publicados = fetchedMembro["posts_publicados"] as? [String] else {
                                    print(#function)
                                    print("Problema ao baixar posts publicados do membro")
                                    return
                                }
                                guard let salvos = fetchedMembro["posts_salvos"] as? [String] else {
                                    print(#function)
                                    print("Problema ao baixar posts salvos do membro")
                                    return
                                }
                                guard let assinaturas = fetchedMembro["assinaturas"] as? [String] else {
                                    print(#function)
                                    print("Problema ao baixar assinaturas do membro")
                                    return
                                }
                                guard let blocked = fetchedMembro["isBlocked"] as? Int else {
                                    print(#function)
                                    print("Problema ao baixar o isBlocked do membro")
                                    return
                                }
                                
                                let is_admin: Bool
                                if admin == 1 { is_admin = true}
                                    else { is_admin = false }
                                
                                let is_blocked: Bool
                                if blocked == 1 { is_blocked = true}
                                    else { is_blocked = false }
                                
                                let membro = Membro(usuario: fetchedUser, idSala: idSala, is_admin: is_admin)
                                membro.id = fetchedMembro.recordID.recordName
                                membro.isBlocked = is_blocked
                                membro.idsPostsPublicados = publicados
                                membro.idsPostsSalvos = salvos
                                membro.idsAssinaturas = assinaturas
                                
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
    
    static func modifyMembro(membro: Membro) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: membro.id)) { (record, error) in
            if let error = error {
                print(#function)
                print("Erro ao buscar membro: \(error)")
                return
            }
            if let fetchedMembroRecord = record {
                fetchedMembroRecord["is_admin"] = membro.isAdmin ? 1 : 0
                fetchedMembroRecord["posts_publicados"] = membro.idsPostsPublicados
                fetchedMembroRecord["posts_salvos"] = membro.idsPostsSalvos
                fetchedMembroRecord["assinaturas"] = membro.idsAssinaturas
                fetchedMembroRecord["isBlocked"] = membro.isBlocked ? 1 : 0
                
                publicDB.save(fetchedMembroRecord) { (record2, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print("Erro ao salvar membro \(error2)")
                        return
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
    
    static func modifyCategoria(_ categoria: Categoria){
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: categoria.id)){ (record, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedCateg = record {
                fetchedCateg["tagsPosts"] = categoria.tagsPosts
                publicDB.save(fetchedCateg) { (record2, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print(error2)
                        return
                    }
                }
            }
        }
    }
    
}

//MARK: - POST
extension CKManager {
    static func savePost(post: Post, completion: @escaping (Result<String, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let postRecord = CKRecord(recordType: "Post")
        postRecord["titulo"] = post.titulo
        postRecord["descricao"] = post.descricao
        if post.link != nil {
            postRecord["link"] = CKRecord.Reference(
                recordID: CKRecord.ID(recordName: post.link!.ckRecordName), action: .none
            )
        }
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
                completion(.success(savedPostRecord.recordID.recordName))
            }
        }
    }
    
    static func modifyPost(_ post: Post) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: post.id)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedPostRecord = fetchedRecord {
                // LISTA DE PERGUNTAS
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
                
                // LISTA DE COMENTARIOS
                var comentarios: [CKRecord.Reference] = []
                for comentario in post.comentarios {
                    comentarios.append(
                        CKRecord.Reference(
                            recordID: CKRecord.ID(recordName: comentario.id),
                            action: .none)
                    )
                }
                fetchedPostRecord["comentarios"] = comentarios
                
                // LISTA DE REPORTS
                fetchedPostRecord["denuncias"] = post.denuncias
                
                publicDB.save(fetchedPostRecord) { (savedRecord, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print(error2)
                        return
                    }
                }
            }
        }
    }
}

//MARK: - LINK
extension CKManager {
    static func saveLink(link: LinkPost, completion: @escaping (Result<String, Error>) -> ()) {
        let linkRecord = CKRecord(recordType: "Link")
        linkRecord["localId"] = link.localId
        linkRecord["titulo"] = link.titulo
        linkRecord["urlString"] = link.urlString
        if let url = link.urlImagem {
            linkRecord["imagem"] = CKAsset(fileURL: url)
        }
        
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.save(linkRecord) { (savedRecord, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let savedLinkRecord = savedRecord {
                completion(.success(savedLinkRecord.recordID.recordName))
                return
            }
        }
    }
    
    static func modifyLink(link: LinkPost) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: link.ckRecordName)) {
            (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
            }
            if let fetchedLinkRecord = fetchedRecord {
                fetchedLinkRecord["imagem"] = CKAsset(fileURL: link.urlImagem!)
                
                publicDB.save(fetchedLinkRecord) { (savedRecord, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print(error2)
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
    
    static func modifyComentario(_ comentario: Comentario){
        // BUSCA O COMENTARIO
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: comentario.id)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedComentarioRecord = fetchedRecord {
                // PREPARA OS DADOS
                fetchedComentarioRecord["votos"] = comentario.votos
                fetchedComentarioRecord["denuncias"] = comentario.denuncias
                
                publicDB.save(fetchedComentarioRecord) { (savedRecord, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print(error2)
                        return
                    }
                }
            }
        }
    }
}

// MARK: - GET FROM DICIONARY
extension CKManager {
    private static func getUsuarioFromDictionary(_ userDictionaryOpt: Dictionary<String, Any>?) -> Usuario? {
//        print("Entrou na função getUserFromDicionary")
        if let usuarioDictionary = userDictionaryOpt {
//            print("Vai pegar recordName do usuario")
            let id = usuarioDictionary["recordName"] as! String
//            print("Vai pegar nome do usuario")
            let nome = usuarioDictionary["nome"] as? String
//            print("Vai pegar fluencia do usuario")
            let fluencia = Usuario.pegaFluencia(
                nome: usuarioDictionary["fluencia_ingles"] as! String
            )
//            print("Vai pegar foto do usuario")
//            let foto: UIImage
            let fotoData = usuarioDictionary["foto_perfil"] as? Data
//            if let fotoData = usuarioDictionary["foto_perfil"] as? Data {
//                foto = UIImage(data: fotoData)!
//            } else {
//                foto = UIImage(named: "perfil")!
//            }
            
//            print("Montando objeto usuario de nome \(String(describing: nome))")
            let usuario = Usuario(
                nome: nome,
                foto_perfil: fotoData/*foto*/,
                fluencia_ingles: fluencia
            )
//            print("Setando id do usuario")
            usuario.id = id
//            print("Returning usuario from dictionary")
            return usuario
        }
//        print(#function)
//        print("usuarioDictionary is nil")
        return nil
    }
    
    private static func getMembroFromDictionary(_ membroDictionaryOpt: Dictionary<String, Any>?) -> Membro? {
        if let membroDictionary = membroDictionaryOpt {
            let usuario = getUsuarioFromDictionary( membroDictionary["usuario"]! as? Dictionary<String,Any>)
            
            let recordName = membroDictionary["recordName"] as! String
            let idSala = membroDictionary["idSala"] as! String
            let admin = membroDictionary["is_admin"] as! Int
            let publicados = membroDictionary["posts_publicados"] as? [String] ?? []
            let salvos = membroDictionary["posts_salvos"] as? [String] ?? []
            let assinaturas = membroDictionary["assinaturas"] as? [String] ?? []
            let blocked = membroDictionary["isBlocked"] as? Int ?? 0
            
            let is_admin: Bool
            if admin == 1 { is_admin = true }
                else { is_admin = false }
            
            let is_blocked: Bool
            if blocked == 1 { is_blocked = true }
                else { is_blocked = false }
            
            let membro = Membro(usuario: usuario!, idSala: idSala, is_admin: is_admin)
            membro.id = recordName
            membro.isBlocked = is_blocked
            membro.idsPostsPublicados = publicados
            membro.idsPostsSalvos = salvos
            membro.idsAssinaturas = assinaturas
            return membro
        }
        return nil
    }
    
    private static func getCategoriaFromDictionary(_ categDictionaryOpt:Dictionary<String, Any>?) -> Categoria? {
//        print("Entrou na funcao getCategoriaFromDictionary")
        if let categDictionary = categDictionaryOpt {
//            print("Pegando o recordName da categoria")
            let id = categDictionary["recordName"] as! String
//            print("Pegando o nome da categoria")
            let nome = categDictionary["nome"] as! String
//            print("Pegando o tagsPosts da categoria")
            let tagsPosts = categDictionary["tagsPosts"] as? [String] ?? []
            
//            print("Montando o objeto da categoria")
            let categoria = Categoria(nome: nome)
            categoria.id = id
            categoria.tagsPosts = tagsPosts
//            print("Returning categoria from dictionary")
            return categoria
            
        }
//        print(#function)
//        print("categDictionary is nil")
        return nil
    }
    
    private static func getComentarioFromDictionary(_ comentarioDictionaryOpt:Dictionary<String, Any>?, with membros: [Membro]) -> Comentario?  {
        if let comentarioDictionary = comentarioDictionaryOpt{
            let recordName = comentarioDictionary["recordName"] as! String
            let conteudo = comentarioDictionary["conteudo"] as! String
            let post = comentarioDictionary["post"] as! String
            let id_publicador = comentarioDictionary["id_publicador"] as! String
            let is_question = comentarioDictionary["is_question"] as! Int == 1 ? true : false
            let votos = comentarioDictionary["votos"] as? [String] ?? []
            let denuncias = comentarioDictionary["denuncias"] as? [String] ?? []
            
            let publicador = membros.filter({$0.id == id_publicador})
            
            let comentario = Comentario(
                post: post,
                publicador: publicador[0],
                conteudo: conteudo,
                is_question: is_question
            )
            comentario.votos = votos
            comentario.denuncias = denuncias
            comentario.id = recordName
//            print("Returning comentario from dictionary")
            return comentario
        }
        return nil
    }
    
    private static func getLinkFromDictionary(_ linkDictionaryOpt:Dictionary<String, Any>?) -> LinkPost?  {
        if let linkDictionary = linkDictionaryOpt{
            let ckRecordName = linkDictionary["recordName"] as! String
            let localId = linkDictionary["localId"] as? Int
            let titulo = linkDictionary["titulo"] as? String
            let urlString = linkDictionary["urlString"] as? String
            
            var foto: Data? = nil
            let fotoDataFromCache = FileSystem.retrieveImage(forId: String(describing: localId))
            let fotoDataFromCK = linkDictionary["imagem"] as! Data?
            
            if fotoDataFromCache != nil { // Primeiro pega no disco
                foto = fotoDataFromCache!
            } else if fotoDataFromCK != nil { // Senao pega no CK
                foto = fotoDataFromCK
            }
            
            let link = LinkPost()
            link.ckRecordName = ckRecordName
            link.localId = localId
            link.titulo = titulo
            link.urlString = urlString
            link.imagem = foto
//            print("Returning link from dictionary")
            return link
        }
        return nil
    }
    
    private static func getPostFromDictionary(_ postDictionaryOpt:Dictionary<String, Any>?, with membros: [Membro]) -> Post? {
        if let postDictionary = postDictionaryOpt {
            if let publicador = getMembroFromDictionary(postDictionary["publicador"] as? Dictionary<String, Any>) {
                // ATRIBUTOS GERAIS DO POST
                let id = postDictionary["recordName"] as! String
                let titulo = postDictionary["titulo"] as! String
                let descricao = postDictionary["descricao"] as! String
                let categs = postDictionary["categorias"] as! [String]
                let tags = postDictionary["tags"] as? [String]
                let denuncias = postDictionary["denuncias"] as? [String]
                let link = getLinkFromDictionary(postDictionary["link"] as? Dictionary<String, Any>)
                
                // PERGUNTAS
                var perguntas: [Comentario] = []
                if let perguntasDicts = postDictionary["perguntas"] as? Array<Dictionary<String,Any>> {
                    for perguntaDict in perguntasDicts {
                        if let pergunta = getComentarioFromDictionary(perguntaDict, with: membros) {
                            perguntas.append(pergunta)
                        }
                    }
                }
                
                // COMENTARIOS
                var comentarios: [Comentario] = []
                if let comentariosDicts = postDictionary["comentarios"] as? Array<Dictionary<String,Any>> {
                    for comentarioDict in comentariosDicts {
                        if let comentario = getComentarioFromDictionary(comentarioDict, with: membros) {
                            comentarios.append(comentario)
                        }
                    }
                }
                
                // MONTAGEM DO POST
                let post = Post(
                    titulo: titulo,
                    descricao: descricao,
                    link: link,
                    categs: categs,
                    tags: "",
                    publicador: publicador
                )
                post.tags = tags ?? []
                post.denuncias = denuncias ?? []
                post.perguntas = perguntas
                post.comentarios = comentarios
                post.id = id
//                print("Returning post from dictionary")
                return post
                
            }
            return nil
        }
        return nil
    }
}
