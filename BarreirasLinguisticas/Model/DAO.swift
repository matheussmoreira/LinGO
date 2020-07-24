//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class DAO: ObservableObject {
    static var unicaInstancia = DAO()
    let id = UUID()
    var nome: String
    var usuarios: [Usuario] = []
    var posts: [Post] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init() {
        self.nome = "Sala 1"
        
        /* **************************************** USUARIOS **************************************** */
        
        /* 0 */self.usuarios.append(Usuario(id: 100, email: "matheus@boladao.com", senha: "sucoDeAbacaxi", nome: "Matheus Moreira", fotoPerfil: "foto_matheus", pais: "EUA", fluenciaIngles: "Intermediario", admin: true, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 1 */self.usuarios.append(Usuario(id: 202, email: "victor@boladao.com", senha: "niteroiAmorzinho", nome: "Victor Duarte", fotoPerfil: "foto_victor", pais: "Espanha", fluenciaIngles: "Intermediario", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 2 */self.usuarios.append(Usuario(id: 31, email: "evelyn@boladona.com", senha: "roxoComAmarelo", nome: "Evelyn de Jesus", fotoPerfil: "foto_evelyn", pais: "Brasil", fluenciaIngles: "Basico", admin: true, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 3 */self.usuarios.append(Usuario(id: 299, email: "leonardo@boladao.com", senha: "monalisa", nome: "Leonardo da Vinci", fotoPerfil: "foto_leo", pais: "Italia", fluenciaIngles: "Zero", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 4 */self.usuarios.append(Usuario(id: 405, email: "michelle@boladona.com", senha: "democracia", nome: "Michelle Obama", fotoPerfil: "foto_michelle", pais: "EUA", fluenciaIngles: "Avancado", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        
        /* **************************************** POSTS ****************************************** */
        
        /* 0 */self.posts.append(Post(id: 555, titulo: "Stop obsessing over user personas", descricao: "People don’t need your product because they belong to a stupid persona", link: nil, categorias: [self.categorias[0]], tags: [self.tags[0],self.tags[1]], autor: self.usuarios[1], apropriado: true))
        /* 1 */self.posts.append(Post(id: 300, titulo: "Geometry in UI Design", descricao: "Because automatic alignment sometimes just doesn’t work", link: nil, categorias: [self.categorias[0]], tags: [self.tags[0]], autor: self.usuarios[1], apropriado: true))
        /* 2 */self.posts.append(Post(id: 301, titulo: "The Mistakes I Made As a Beginner Programmer", descricao: "Learn to identify them, make habits to avoid them", link: nil, categorias: [self.categorias[1]], tags: [], autor: self.usuarios[0], apropriado: true))
        /* 3 */self.posts.append(Post(id: 412, titulo: "SwiftUI: a new perception of developing", descricao: "This article is not intended to be a simplifying way to say that programming is “easy”. Of course there are many notions and concepts to learn but with the right motivation and with the right tools nothing is impossible. However, it can be said that with SwiftUI, everyone can program in a easier way. It is not important what your background is but the goals you want to achieve and your motivation", link: nil, categorias: [self.categorias[1]], tags: [self.tags[4]], autor: self.usuarios[2], apropriado: true))
        /* 4 */self.posts.append(Post(id: 413, titulo: "The 10 Qualities of an Emotionally Intelligent Person", descricao: nil, link: nil, categorias: [self.categorias[4]], tags: [self.tags[11]], autor: self.usuarios[2], apropriado: true))
        /* 5 */self.posts.append(Post(id: 414, titulo: "6 Principles Of Visual Accessibility Design", descricao: "According to the World Health Organization, 285 million people in the world are visually impaired. These 285 million people still need access to the Internet, and deserve to have access to the same information that everybody else does. Many individuals believe that if someone is visually impaired, they do not use the Internet. This is untrue.", link: nil, categorias: [self.categorias[2]], tags: [self.tags[12]], autor: self.usuarios[2], apropriado: true))
        
        /* ************************************** CATEGORIAS **************************************** */
        
        /* 0 */self.categorias.append(Categoria(id: 35, nome: "Design", tags: [self.tags[0],self.tags[1],self.tags[2],self.tags[4],self.tags[6]], posts: [self.posts[0], self.posts[1]], inscritos: []))
        /* 1 */self.categorias.append(Categoria(id: 444, nome: "Programação", tags: [self.tags[3],self.tags[4],self.tags[5]], posts: [self.posts[2], self.posts[3]], inscritos: []))
        /* 2 */self.categorias.append(Categoria(id: 909, nome: "Acessibilidade", tags: [self.tags[6]], posts: [self.posts[5]], inscritos: []))
        /* 3 */self.categorias.append(Categoria(id: 101, nome: "Jogos", tags: [self.tags[7],self.tags[8]], posts: [], inscritos: []))
        /* 4 */self.categorias.append(Categoria(id: 199, nome: "Negócios", tags: [self.tags[9],self.tags[10]], posts: [], inscritos: []))
        
        /* **************************************** TAGS ****************************************** */
        
        /* 0 */self.tags.append(Tag(id: 90, nome: "UX", categorias: [self.categorias[0]], posts: [self.posts[0], self.posts[1]]))
        /* 1 */self.tags.append(Tag(id: 88, nome: "Personas", categorias: [self.categorias[0]], posts: [self.posts[0]]))
        /* 3 */self.tags.append(Tag(id: 235, nome: "Git", categorias: [self.categorias[1]], posts: []))
        /* 4 */self.tags.append(Tag(id: 667, nome: "SwiftUI", categorias: [self.categorias[0], self.categorias[1]], posts: [self.posts[3]]))
        /* 5 */self.tags.append(Tag(id: 505, nome: "JSON", categorias: [self.categorias[1]], posts: []))
        /* 6 */self.tags.append(Tag(id: 783, nome: "Cores", categorias: [self.categorias[0], self.categorias[2]], posts: []))
        /* 7 */self.tags.append(Tag(id: 786, nome: "Efeitos Sonoros", categorias: [self.categorias[3]], posts: []))
        /* 8 */self.tags.append(Tag(id: 200, nome: "Personagens", categorias: [self.categorias[3]], posts: []))
        /* 9 */self.tags.append(Tag(id: 551, nome: "App Store", categorias: [self.categorias[4]], posts: []))
        /* 10 */self.tags.append(Tag(id: 409, nome: "Comprar In-App", categorias: [self.categorias[4]], posts: []))
        /* 11 */self.tags.append(Tag(id: 88, nome: "Autoconhecimento", categorias: [self.categorias[4]], posts: [self.posts[4]]))
        /* 12 */self.tags.append(Tag(id: 88, nome: "Acessibilidade Visual", categorias: [self.categorias[2]], posts: [self.posts[5]]))

    }
}
