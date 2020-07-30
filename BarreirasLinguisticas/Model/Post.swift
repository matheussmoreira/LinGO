//
//  Post.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class Post: Identifiable, ObservableObject {
    let id: Int // = UUID()
    var titulo: String
    var descricao: String?
    var link: Link?
    var link_image: UIImage?
    var link_icon: UIImage?
    //var date = Date()
    let publicador: Membro
    var improprio = false
    //var comentarios: [Comentario] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init(id: Int, titulo: String?, descricao: String?, link: Link?, publicador: Membro) {
        self.id = id
        self.titulo = titulo ?? "Post sem título"
        self.descricao = descricao ?? ""
        self.link = link
        self.publicador = publicador
    }
    
    /*func debug(){
        print("\nPOST DEBUG")
        print("Id: \(self.id)")
        print("Titulo: \(self.titulo)")
        print("Descricao: \(self.descricao ?? "Sem descrição")")
        print("Titulo do link: \(self.link?.metadata?.title ?? "Sem titulo link")")
        print("Publicador: \(self.publicador.nome) de id \(self.publicador.id)")
        print("Improprio: \(self.improprio)")
        for cat in self.categorias{
            print("Categoria: \(cat.nome) de id \(cat.id)")
        }
        for tag in self.tags{
            print("Tag: \(tag.nome) de id \(tag.id)")
        }
        print("\n")
    }*/
    
    func addCategoria(categoria: Categoria?) {
        if (categoria != nil) { self.categorias.append(categoria!)}
        else { print("Post com categoria inválida") }
    }
    
    func addTag(tag: Tag?) {
        if (tag != nil) { self.tags.append(tag!) }
        else { print("Categoria com tag inválida") }
    }
    
    func addLink(link: Link?) {
        if (link != nil) {
            self.link = link!
            addLinkImage(from: link!)
            addLinkIcon(from: link!)
        }
        else { print("Não deu pra adquirir o link, está inválido") }
    }
    
    func addLinkImage(from link: Link) {
        let md = link.metadata
        let _ = md?.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { (image, err) in
            DispatchQueue.main.async {
                self.link_image = image as? UIImage
            }
        })
    }
    
    func addLinkIcon(from link: Link) {
        let md = link.metadata
        let _ = md?.iconProvider?.loadObject(ofClass: UIImage.self, completionHandler: { (icon, err) in
            DispatchQueue.main.async {
                self.link_icon = icon as? UIImage
            }
        })
    }
    
}
