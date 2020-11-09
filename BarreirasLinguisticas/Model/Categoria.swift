//
//  Categoria.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Categoria: Equatable, Identifiable, ObservableObject {
    var id: String = ""// {self.recordName ?? ""}//String(self.hashValue)}
    @Published var nome: String
    @Published var tagsPosts: [String] = []
//    @Published var posts: [String] = []
    
    init(nome: String?) {
        self.nome = nome ?? "<Nome Categoria>"
    }
    
    static func == (lhs: Categoria, rhs: Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
//    func addPost(post: String?) {
//        if (post != nil) {
//            self.posts.append(post!)
//            addPostsTags(post: post!)
//        }
//        else { print("Categoria com post inválido") }
//    }
    
    func addPostTags(post: Post) {
        for tag in post.tags{
            if !self.tagsPosts.contains(tag) {
                self.tagsPosts.append(tag)
                CKManager.modifyCategoriaTagsPosts(categoria: self) { (result) in
                    switch result {
                        case .success(_):
                            break
                        case .failure(let error):
                            print(#function)
                            print(error)
                    }
                }
            }
        }
    }
    
}
