//
//  Comentario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Comentario: Identifiable, ObservableObject {
    var recordName: String?
    var id: String {self.recordName ?? ""}//String(self.hashValue)}
    @Published var post: Post
    @Published var publicador: Membro
    @Published var conteudo: String
    @Published var is_question: Bool
    @Published var votos: [Membro] = []
    @Published var original: Comentario?
    @Published var replies: [Comentario] = []
    @Published var improprio = false
    
    init(post: Post, publicador: Membro, conteudo: String, is_question: Bool, original: Comentario?) {
        self.post = post
        self.publicador = publicador
        self.conteudo = conteudo
        self.is_question = is_question
        self.original = original
    }
    
    func ganhaVoto(de membro: Membro){
        votos.append(membro)
    }
    
    func perdeVoto(de membro: Membro){
        self.votos.removeAll(where: {$0.usuario.id == membro.usuario.id})
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
