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
    var publicador: Membro
    var conteudo: String
    var data = Date()
    var is_question: Bool
    var votos: [Voto] = []
    var original: Comentario?
    var replies: [Comentario] = []
    var improprio = false
    
    init(id: Int, post: Post, publicador: Membro, conteudo: String, is_question: Bool, original: Comentario?) {
        self.id = id
        self.post = post
        self.publicador = publicador
        self.conteudo = conteudo
        self.is_question = is_question
        self.original = original
    }
    
    func ganhaVoto(membro: Membro){
        votos.append(Voto(membro: membro))
    }
    
    func getVotoIndex(id: Int) -> Int? {
        var idx = 0
        for voto in votos {
            if voto.membro.usuario.id == id {
                return idx
            }
            else {
              idx += 1
            }
        }
        return nil
    }
    
    func perdeVoto(membro: Membro?){
        if (membro != nil) {
            if let idx = getVotoIndex(id: membro!.usuario.id) {
                self.votos.remove(at: idx)
            }
            else {
                print("Autor do voto não encontrado")
            }
        }
        else {
            print("Voto a ser removido inválido")
        }
    }
}
