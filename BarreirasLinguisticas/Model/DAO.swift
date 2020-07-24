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
        
        /* 0 */self.usuarios.append(Usuario(id: 100, email: "matheus@boladao.com", senha: "sucoDeAbacaxi", nome: "Matheus Moreira", fotoPerfil: "foto_matheus", pais: "USA", fluenciaIngles: "Intermediate", admin: true, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 1 */self.usuarios.append(Usuario(id: 202, email: "victor@boladao.com", senha: "niteroiAmorzinho", nome: "Victor Duarte", fotoPerfil: "foto_victor", pais: "Spain", fluenciaIngles: "Intermediate", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 2 */self.usuarios.append(Usuario(id: 31, email: "evelyn@boladona.com", senha: "roxoComAmarelo", nome: "Evelyn de Jesus", fotoPerfil: "foto_evelyn", pais: "Brazil", fluenciaIngles: "Basic", admin: true, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 3 */self.usuarios.append(Usuario(id: 299, email: "leonardo@boladao.com", senha: "monalisa", nome: "Leonardo da Vinci", fotoPerfil: "foto_leo", pais: "Italy", fluenciaIngles: "Zero", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        /* 4 */self.usuarios.append(Usuario(id: 405, email: "michelle@boladona.com", senha: "democracia", nome: "Michelle Obama", fotoPerfil: "foto_michelle", pais: "USA", fluenciaIngles: "Advanced", admin: false, inscricoes: [], postsSalvos: [], postsPublicados: []))
        
        /* **************************************** POSTS ****************************************** */
        
        /* 0 */self.posts.append(Post(id: 555, titulo: "Stop obsessing over user personas", descricao: "People don’t need your product because they belong to a stupid persona", link: nil, categorias: [], tags: [], autor: self.usuarios[1], apropriado: true))
        /* 1 */self.posts.append(Post(id: 300, titulo: "Geometry in UI Design", descricao: "Because automatic alignment sometimes just doesn’t work", link: nil, categorias: [], tags: [], autor: self.usuarios[1], apropriado: true))
        /* 2 */self.posts.append(Post(id: 301, titulo: "The Mistakes I Made As a Beginner Programmer", descricao: "Learn to identify them, make habits to avoid them", link: nil, categorias: [], tags: [], autor: self.usuarios[0], apropriado: true))
        /* 3 */self.posts.append(Post(id: 412, titulo: "SwiftUI: a new perception of developing", descricao: "This article is not intended to be a simplifying way to say that programming is “easy”. Of course there are many notions and concepts to learn but with the right motivation and with the right tools nothing is impossible. However, it can be said that with SwiftUI, everyone can program in a easier way. It is not important what your background is but the goals you want to achieve and your motivation", link: nil, categorias: [], tags: [], autor: self.usuarios[2], apropriado: true))
        /* 4 */self.posts.append(Post(id: 413, titulo: "The 10 Qualities of an Emotionally Intelligent Person", descricao: nil, link: nil, categorias: [], tags: [], autor: self.usuarios[2], apropriado: true))
        /* 5 */self.posts.append(Post(id: 414, titulo: "6 Principles Of Visual Accessibility Design", descricao: "According to the World Health Organization, 285 million people in the world are visually impaired. These 285 million people still need access to the Internet, and deserve to have access to the same information that everybody else does. Many individuals believe that if someone is visually impaired, they do not use the Internet. This is untrue.", link: nil, categorias: [], tags: [], autor: self.usuarios[2], apropriado: true))
        
        /* ************************************** CATEGORIAS **************************************** */
        
        /* 0 */self.categorias.append(Categoria(id: 35, nome: "Design", tags: [], posts: [], inscritos: []))
        /* 1 */self.categorias.append(Categoria(id: 444, nome: "Programming", tags: [], posts: [], inscritos: []))
        /* 2 */self.categorias.append(Categoria(id: 909, nome: "Accessibility", tags: [], posts: [], inscritos: []))
        /* 3 */self.categorias.append(Categoria(id: 101, nome: "Games", tags: [], posts: [], inscritos: []))
        /* 4 */self.categorias.append(Categoria(id: 199, nome: "Business", tags: [], posts: [], inscritos: []))
        
        /* **************************************** TAGS ****************************************** */
        
        /* 0 */self.tags.append(Tag(id: 90, nome: "UX", categorias: [], posts: []))
        /* 1 */self.tags.append(Tag(id: 88, nome: "Personas", categorias: [], posts: []))
        /* 2 */self.tags.append(Tag(id: 235, nome: "Git", categorias: [], posts: []))
        /* 3 */self.tags.append(Tag(id: 667, nome: "SwiftUI", categorias: [], posts: []))
        /* 4 */self.tags.append(Tag(id: 505, nome: "JSON", categorias: [], posts: []))
        /* 5 */self.tags.append(Tag(id: 783, nome: "Colors", categorias: [], posts: []))
        /* 6 */self.tags.append(Tag(id: 786, nome: "Sound Effects", categorias: [], posts: []))
        /* 7 */self.tags.append(Tag(id: 200, nome: "Characters", categorias: [], posts: []))
        /* 8 */self.tags.append(Tag(id: 551, nome: "App Store", categorias: [], posts: []))
        /* 9 */self.tags.append(Tag(id: 409, nome: "In-App Purchases", categorias: [], posts: []))
        /* 10 */self.tags.append(Tag(id: 88, nome: "Self-knowledge", categorias: [], posts: []))
        /* 11 */self.tags.append(Tag(id: 88, nome: "Visual Accessibility", categorias: [], posts: []))
        
        /* ******************************** TAGS DAS CATEGORIAS ********************************** */
         
        self.categorias[0].tags = [self.tags[0],self.tags[1],self.tags[3],self.tags[5],self.tags[11]]
        self.categorias[1].tags = [self.tags[2],self.tags[3],self.tags[4]]
        self.categorias[2].tags = [self.tags[5],self.tags[6],self.tags[11]]
        self.categorias[3].tags = [self.tags[6],self.tags[7]]
        self.categorias[4].tags = [self.tags[8],self.tags[9],self.tags[10]]
        
        /* ********************************** CATEGORIAS DAS TAGS ********************************** */
        self.tags[0].categorias = [self.categorias[0]]
        self.tags[1].categorias = [self.categorias[0]]
        self.tags[2].categorias = [self.categorias[1]]
        self.tags[3].categorias = [self.categorias[0],self.categorias[1]]
        self.tags[4].categorias = [self.categorias[1]]
        self.tags[5].categorias = [self.categorias[0],self.categorias[2]]
        self.tags[6].categorias = [self.categorias[2],self.categorias[3]]
        self.tags[7].categorias = [self.categorias[3]]
        self.tags[8].categorias = [self.categorias[4]]
        self.tags[9].categorias = [self.categorias[4]]
        self.tags[10].categorias = [self.categorias[4]]
        self.tags[11].categorias = [self.categorias[0],self.categorias[2]]
        
        /* ********************************* POSTS DAS CATEGORIAS ******************************** */
        
        self.categorias[0].posts = [self.posts[0],self.posts[1],self.posts[3],self.posts[5]]
        self.categorias[1].posts = [self.posts[2],self.posts[3]]
        self.categorias[2].posts = [self.posts[5]]
        self.categorias[4].posts = [self.posts[4]]
        
        /* ******************************* CATEGORIAS DOS POSTS ************************************ */
        
        self.posts[0].categorias = [self.categorias[0]]
        self.posts[1].categorias = [self.categorias[0]]
        self.posts[2].categorias = [self.categorias[1]]
        self.posts[3].categorias = [self.categorias[1],self.categorias[0]]
        self.posts[4].categorias = [self.categorias[4]]
        self.posts[5].categorias = [self.categorias[2],self.categorias[0]]
        
        /* ********************************* POSTS DAS TAGS **************************************** */
        
        self.tags[0].posts = [self.posts[0],self.posts[1]]
        self.tags[1].posts = [self.posts[0]]
        self.tags[3].posts = [self.posts[3]]
        self.tags[10].posts = [self.posts[4]]
        self.tags[11].posts = [self.posts[5]]
        
        /* ********************************** TAGS DOS POSTS **************************************** */
        
        self.posts[0].tags = [self.tags[0],self.tags[1]]
        self.posts[1].tags = [self.tags[0]]
        self.posts[3].tags = [self.tags[3]]
        self.posts[4].tags = [self.tags[10]]
        self.posts[5].tags = [self.tags[11]]

    }
}
