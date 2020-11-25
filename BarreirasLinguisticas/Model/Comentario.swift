//
//  Comentario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Comentario: Identifiable, ObservableObject {
    var id: String = ""
    @Published var post: String
    @Published var publicador: Membro
    @Published var conteudo: String
    @Published var is_question: Bool
    @Published var votos: [String] = []
    @Published var denuncias: [String] = []
    
    init(post: String, publicador: Membro, conteudo: String, is_question: Bool) {
        self.post = post
        self.publicador = publicador
        self.conteudo = conteudo
        self.is_question = is_question
    }
    
    func ganhaVoto(de membro: Membro){
        votos.append(membro.id)
        CKManager.modifyComentario(self)
    }
    
    func perdeVoto(de membro: Membro){
        votos.removeAll(where: {$0 == membro.id})
        CKManager.modifyComentario(self)
    }
    
    
    func checkVotoExists(membro: Membro) -> Bool {
        for membro_voto in votos {
            if membro_voto == membro.id {
                return true
            }
        }
        return false
    }
    
    func updateReportStatus(membro: Membro){
        if !denuncias.contains(membro.id) {
            denuncias.append(membro.id)
        }
        else {
            denuncias.removeAll(where: {$0 == membro.id})
        }
        CKManager.modifyComentario(self)
    }
    
}
