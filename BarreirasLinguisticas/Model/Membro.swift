//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

class Membro: Equatable, Identifiable, ObservableObject {
    var id: String = ""
    var usuario: Usuario
    var idSala: String
    var isAdmin: Bool
    @Published var idsAssinaturas: [String] = []
    @Published var idsPostsSalvos: [String] = []
    @Published var idsPostsPublicados: [String] = []
    @Published var reports: [String] = []
    @Published var isBlocked = false
    
    init (usuario: Usuario, idSala: String, is_admin: Bool) {
        self.usuario = usuario
        self.idSala = idSala
        self.isAdmin = is_admin
    }
    
    static func == (lhs: Membro, rhs: Membro) -> Bool {
        return lhs.usuario.id == rhs.usuario.id
    }
    
    // MARK: - NOVOS
    func updateAdminStatus(){
        isAdmin.toggle()
        CKManager.modifyMembro(membro: self)
    }
    
    func updateBlockedStatus(){
        isBlocked.toggle()
        CKManager.modifyMembro(membro: self)
    }
    
    func assinaCategoria(categoria categ: String?) {
        if (categ != nil) {
            self.idsAssinaturas.append(categ!)
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Categoria a ser assinada inválida")
        }
    }
    
    func salvaPost(post: String?) {
        if (post != nil) {
            self.idsPostsSalvos.append(post!)
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Post a ser salvo não definido")
        }
    }
    
    func publicaPost(post: String?) {
        if (post != nil) {
            self.idsPostsPublicados.append(post!)
            CKManager.modifyMembro(membro: self)
        }
        else { print("Post a ser publicado inválido") }
    }
    
    //MARK: - DELECOES
    
    func removeAssinatura(categoria categ: String?) {
        if (categ != nil) {
            self.idsAssinaturas.removeAll(where: {$0 == categ!})
            CKManager.modifyMembro(membro: self)
        }
        else {
            print("Categoria a ser removida inválida")
        }
    }
    
    func apagaPost(post: String?) {
        if (post != nil) {
            idsPostsPublicados.removeAll(where: {$0 == post})
            CKManager.modifyMembro(membro: self)
        }
        else { print("Post a ser publicado é inválido") }
    }
    
    func removePostSalvo(post: String?) {
        if (post != nil) {
            if let idx = getPostSalvoIndex(id: post!) {
                self.idsPostsSalvos.remove(at: idx)
                CKManager.modifyMembro(membro: self)
            }
            else {
                print("Post salvo não encontrado")
            }
        }
        else {
            print("Posts salvo a ser removido inválido")
        }
    }
    
    //MARK: - FUNCOES GET
    func getPostSalvoIndex(id: String?) -> Int? {
        var idx = 0
        for salvo in idsPostsSalvos {
            if salvo == id {
                return idx
            }
            else {
                idx += 1
            }
        }
        return nil
    }
    
    func getAssinaturaIndex(id: String) -> Int? {
        var idx = 0
        for asst in idsAssinaturas {
            if asst == id {
                return idx
            }
            else {
                idx += 1
            }
        }
        return nil
    }
    
}
