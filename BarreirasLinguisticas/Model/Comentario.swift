//
//  Comentario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Comentario: Identifiable, ObservableObject {
    let id: Int
    var post: Post
    @Published var publicador: Membro
    @Published var conteudo: String
    //var data = Date()
    var is_question: Bool
    @Published var votos: [Membro] = []
    @Published var original: Comentario?
    @Published var replies: [Comentario] = []
    var improprio = false
    
    init(id: Int, post: Post, publicador: Membro, conteudo: String, is_question: Bool, original: Comentario?) {
        self.id = id
        self.post = post
        self.publicador = publicador
        self.conteudo = conteudo
        self.is_question = is_question
        self.original = original
    }
    
    func ganhaVoto(de membro: Membro){
        votos.append(membro)
    }
    
//    func getVotoIndex(id: Int) -> Int? {
//        var idx = 0
//        for membro_voto in votos {
//            if membro_voto.usuario.id == id {
//                return idx
//            }
//            else {
//              idx += 1
//            }
//        }
//        return nil
//    }
    
    func perdeVoto(de membro: Membro){
        //if let idx = getVotoIndex(id: membro.usuario.id) {
            //self.votos.remove(at: idx)
            self.votos.removeAll(where: {$0.usuario.id == membro.usuario.id})
        //}
        //else {
            //print("Autor do voto não encontrado")
        //}
    }
    
    func checkVotoExists(membro: Membro) -> Bool {
        for membro_voto in votos {
            if membro_voto.usuario.id == membro.usuario.id {
                return true
            }
        }
        return false
    }
}
