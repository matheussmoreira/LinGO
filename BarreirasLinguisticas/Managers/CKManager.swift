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
    static func deleteRecord(recordName: String, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.delete(withRecordID: CKRecord.ID(recordName: recordName)) { (recordID, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let recordID = recordID {
                print("deleteRecord1: Objeto de recordName \(recordID.recordName) deletado com sucesso!")
                completion(.success(recordID))
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
            if let recordID = recordID {
                print("deleteRecord2: Objeto de recordName \(recordID.recordName) deletado com sucesso!")
            }
        }
    }
    
}

// MARK: - SALA
extension CKManager {
    static func querySalasRecords(completion: @escaping (Result<[CKRecord], Error>) -> ()){
        let publicDB = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Sala", predicate: NSPredicate(value: true))
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let loadedSalas = records {
                completion(.success(loadedSalas))
            }
        }
    }
    
    static func saveSala(nome: String, completion: @escaping (Result<Sala, Error>) -> ()) {
        let publicDB = CKContainer.default().publicCloudDatabase
        let salaRecord = CKRecord(recordType: "Sala")
        salaRecord["nome"] = nome
        
        publicDB.save(salaRecord){ (record, error) in
            if let error = error {
                print(#function)
                print(error)
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
        print("Entrando em modifySala")
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: sala.id)) { (record, error) in
            if let error = error {
                print(#function)
                print(error)
                return
            }
            if let fetchedSala = record {
                // QUANT COMENTARIOS
                fetchedSala["quantComentarios"] = sala.quantComentarios
                
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
        print("Entrando em modifySalaPosts")
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
//        print("\tFetching usuario")
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let record = record {
                // SEM GUARD LET POR CONTA DA CRIACAO DE UM NOVO USUARIO
//                print("\tUsuario fetched!")
                let id = record.recordID.recordName
                let nome = record["nome"] as? String
                let fluencia = record["fluencia_ingles"] as? String
                let sala_atual = record["sala_atual"] as? String
                var foto: Data? = nil
                
                if let fotoData = FileSystem.retrieveImage(forId: id) {
                    // Primeiro busca no disco
                    foto = fotoData
                } else if let fotoAsset = record["foto_perfil"] as? CKAsset {
                    // Depois busca no CK
                    foto = NSData(contentsOf: fotoAsset.fileURL!) as Data?
                }
                
                let fetchedUser = Usuario(
                    nome: nome,
                    foto_perfil: foto,
                    fluencia_ingles: Usuario.getFluenciaByNome(fluencia ?? "")
                )
                fetchedUser.id = id
                fetchedUser.sala_atual = sala_atual
//                print("\tRetornando usuario")
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
                fetchedRecord["fluencia_ingles"] = user.fluencia_ingles.rawValue
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
    
    static func fetchLink(recordName: String, completion: @escaping (Result<LinkPost,Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
                let recordName = record.recordID.recordName
                guard let localId = record["localId"] as? Int else{
                    print("\(#function) - Erro no cast do localId")
                    return
                }
                guard let titulo = record["titulo"] as? String else{
                    print("\(#function) - Erro no cast do titulo")
                    return
                }
                guard let urlString = record["urlString"] as? String else{
                    print("\(#function) - Erro no cast da urlString")
                    return
                }
                var foto: Data? = nil
                let fotoDataFromCache = FileSystem.retrieveImage(forId: String(describing: localId))
                let fotoAsset = record["imagem"] as? CKAsset
                
                if fotoDataFromCache != nil { // Primeiro pega no disco
                    foto = fotoDataFromCache!
                } else if fotoAsset != nil { // Senao pega no CK
                    foto = NSData(contentsOf: fotoAsset!.fileURL!) as Data?
                }
                
                let link = LinkPost()
                link.ckRecordName = recordName
                link.localId = localId
                link.titulo = titulo
                link.urlString = urlString
                link.imagem = foto
                completion(.success(link))
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
                if let imagem = link.urlImagem {
                    fetchedLinkRecord["imagem"] = CKAsset(fileURL: imagem)
                }
                
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
    static func saveComentario(_ comentario: Comentario, completion: @escaping (Result<String, Error>) -> ()) {
        // PREPARANDO OS DADOS
        let comentarioRecord = CKRecord(recordType: "Comentario")
        comentarioRecord["post"] = comentario.post
        comentarioRecord["id_publicador"] = comentario.publicador.id
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
    
    static func fetchComentario(recordName: String, completion: @escaping (Result<Comentario, Error>) -> ()){
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = fetchedRecord {
                guard let publicadorRef = record["id_publicador"] as? CKRecord.Reference else { return }
                fetchMembro(recordName: publicadorRef.recordID.recordName) { (resultMembro) in
                    switch resultMembro {
                        case .success(let fetchedMembro):
                            let recordName = record.recordID.recordName
                            guard let post = record["post"] as? String else { return }
                            guard let conteudo = record["conteudo"] as? String else { return }
                            guard let question = record["is_question"] as? Int else { return }
                            
                            var is_question: Bool
                            (question == 1) ? (is_question = true) : (is_question = false)
                            let votos = record["votos"] as? [String] ?? []
                            let denuncias = record["denuncias"] as? [String] ?? []
                            
                            let comentario = Comentario(post: post, publicador: fetchedMembro, conteudo: conteudo, is_question: is_question)
                            comentario.votos = votos
                            comentario.denuncias = denuncias
                            comentario.id = recordName
                            completion(.success(comentario))
                        case .failure(let error2):
                            print(error2)
                            completion(.failure(error2))
                    }
                }
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
                var respostas: [String] = []
                for resposta in comentario.respostas {
                    respostas.append(resposta.id)
                }
                fetchedComentarioRecord["respostas"] = respostas
                
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

//MARK: - RESPOSTA
extension CKManager {
    static func saveResposta(_ resposta: Resposta, completion: @escaping (Result<String, Error>) -> ()){
        let respostaRecord = CKRecord(recordType: "Resposta")
        respostaRecord["id_original"] = resposta.id_original
        respostaRecord["publicador"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: resposta.publicador.id), action: .deleteSelf)
        respostaRecord["conteudo"] = resposta.conteudo
        
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.save(respostaRecord) { (savedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
                completion(.failure(error))
            }
            if let record = savedRecord {
                let recordName = record.recordID.recordName
                completion(.success(recordName))
            }
        }
    }
    
    static func modifyResposta(_ resposta: Resposta) {
        let publicDB = CKContainer.default().publicCloudDatabase
        publicDB.fetch(withRecordID: CKRecord.ID(recordName: resposta.id)) { (fetchedRecord, error) in
            if let error = error {
                print(#function)
                print(error)
            }
            if let record = fetchedRecord {
                record["denuncias"] = resposta.denuncias
                publicDB.save(record) { (savedRecord, error2) in
                    if let error2 = error2 {
                        print(#function)
                        print(error2)
                    }
                }
            }
        }
    }
}
