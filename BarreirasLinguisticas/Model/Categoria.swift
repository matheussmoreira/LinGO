//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

class Categoria: Equatable, Identifiable, ObservableObject, CKMRecord {
    var recordName: String?
    var id: String {self.recordName ?? String(self.hashValue)}
    @Published var nome: String
    @Published var tagsPosts: [String] = []
    @Published var posts: [Post] = []
    
    init(nome: String?) {
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
    func addPost(post: Post?) {
        if (post != nil) {
            self.posts.append(post!)
            addPostsTags(post: post!)
        }
        else { print("Categoria com post inválido") }
    }
    
    func addPostsTags(post: Post) {
        for tag in post.tags{
            if !self.tagsPosts.contains(tag) {
                self.tagsPosts.append(tag)
            }
        }
    }
    
}
