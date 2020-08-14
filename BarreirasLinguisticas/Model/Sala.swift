//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class Sala: Identifiable, ObservableObject {
    let id: Int
    @Published var nome: String
    @Published var admins: [Membro] = []
    @Published var membros: [Membro] = []
    @Published var posts: [Post] = []
    @Published var categorias: [Categoria] = []
    @Published var tags: [Tag] = []
    var link_manager = LinkManager()
    
    init(id: Int, nome: String, criador: Usuario) {
        self.id = id
        self.nome = nome
        novoMembro(id: criador.id, is_admin: true)
        
        if (self.id == 1) { //so populando com dados a primeira sala
            //MARK: - MEMBROS
            novoMembro(id: 1, is_admin: true)
            novoMembro(id: 2, is_admin: false)
            novoMembro(id: 3, is_admin: true)
            novoMembro(id: 4, is_admin: false)
            novoMembro(id: 5, is_admin: false)
            novoMembro(id: 6, is_admin: true)
            novoMembro(id: 7, is_admin: false)
            novoMembro(id: 8, is_admin: false)
            novoMembro(id: 9, is_admin: false)
            novoMembro(id: 10, is_admin: false)
            
            //MARK: - CATEGORIAS
            novaCategoria(id: 1, nome: "Design")
            novaCategoria(id: 2, nome: "Programming")
            novaCategoria(id: 3, nome: "Accessibility")
            novaCategoria(id: 4, nome: "Games")
            novaCategoria(id: 5, nome: "Business")
            novaCategoria(id: 6, nome: "WWDC")
            novaCategoria(id: 7, nome: "Data Science")
            novaCategoria(id: 8, nome: "Entrepeneurship")
            novaCategoria(id: 9, nome: "English Language")
            //novaCategoria(id: 10, nome: "#New Categorie for tests")
            
            //MARK: - TAGSS
            novaTag(id: 1,  nome: "UX",                   categs: [1])
            novaTag(id: 2,  nome: "Personas",             categs: [1])
            novaTag(id: 3,  nome: "Git",                  categs: [2])
            novaTag(id: 4,  nome: "SwiftUI",              categs: [1,2])
            novaTag(id: 5,  nome: "JSON",                 categs: [2])
            novaTag(id: 6,  nome: "Colors",               categs: [1,3])
            novaTag(id: 7,  nome: "Sound Effects",        categs: [3,4])
            novaTag(id: 8,  nome: "Characters",           categs: [4])
            novaTag(id: 9,  nome: "App Store",            categs: [5])
            novaTag(id: 10, nome: "In-App Purchases",     categs: [5])
            novaTag(id: 11, nome: "Self-Knowledge",       categs: [8])
            novaTag(id: 12, nome: "Visual Accessibility", categs: [1,3])
            novaTag(id: 13, nome: "Swift Playgrounds",    categs: [4,6])
            novaTag(id: 14, nome: "Grammar",              categs: [9])
            
            //MARK: - POSTS
            novoPost(publicador: 2,
                     post: 1,
                     titulo: "Design is eating code, even as software eats the world",
                     descricao: "Product design today lets builders go faster and further than ever—how did this happen and what comes next?",
                     link: Link(urlString: "https://uxdesign.cc/design-is-eating-code-even-as-software-eats-the-world-f40195982a08"),
                     categs: [1],
                     tags: [1,2])
            
            novoPost(publicador: 2,
                     post: 2,
                     titulo: "Geometry in UI Design",
                     descricao: "Because automatic alignment sometimes just doesn’t work",
                     link: Link(urlString: "https://medium.com/design-notes/geometry-in-ui-design-61ef4f88218a"),
                     categs: [1],
                     tags: [1])
            
            novoPost(publicador: 1,
                     post: 3,
                     titulo: "The Mistakes I Made As a Beginner Programmer",
                     descricao: "Learn to identify them, make habits to avoid them",
                     link: Link(urlString: "https://medium.com/edge-coders/the-mistakes-i-made-as-a-beginner-programmer-ac8b3e54c312"),
                     categs: [2],
                     tags: [])
            
            novoPost(publicador: 4,
                     post: 4,
                     titulo: "SwiftUI: a new perception of developing",
                     descricao: "This article is not intended to be a simplifying way to say that programming is “easy”. Of course there are many notions and concepts to learn but with the right motivation and with the right tools nothing is impossible. However, it can be said that with SwiftUI, everyone can program in a easier way. It is not important what your background is but the goals you want to achieve and your motivation",
                     link: Link(urlString: "https://medium.com/apple-developer-academy-federico-ii/swiftui-a-new-perception-of-developing-780906ee492a"),
                     categs: [1,2],
                     tags: [4])
            
            novoPost(publicador: 3,
                     post: 5,
                     titulo: "The 10 Qualities of an Emotionally Intelligent Person",
                     descricao: nil,
                     link: Link(urlString: "https://medium.com/personal-growth/the-10-qualities-of-an-emotionally-intelligent-person-f595440af4fb"),
                     categs: [8],
                     tags: [11])
            
            novoPost(publicador: 6,
                     post: 6, titulo: "6 Principles Of Visual Accessibility Design",
                     descricao: "According to the World Health Organization, 285 million people in the world are visually impaired. These 285 million people still need access to the Internet, and deserve to have access to the same information that everybody else does. Many individuals believe that if someone is visually impaired, they do not use the Internet. This is untrue.",
                     link: Link(urlString: "https://usabilitygeek.com/6-principles-visual-accessibility-design/"),
                     categs: [3],
                     tags: [12])
            
            novoPost(publicador: 3,
            post: 7, titulo: "The Day I First Met a Foreign",
            descricao: "It was an exchange fair. First, I met a man from San Francisco... he sells hamburguers and hotdogs and he's very kind and he likes talking about his country and culture. I also met a female teacher from France who speaks English... and she was too distant and cold, I didn't feel like she enjoyed meeting me. I also met a woman from Florida who was a true christian and was always talking about Jesus... which I liked because wherever we used to go she was always finding something good in things. I love the fact that I have met, worked with and become friends from so many foreign countries. I have had some experiences which have caused me to form opinions about certain countries. But I really try not to do this if possible. People are just people after all... we all have our good points and our bad points. What about you?",
            link: nil,
            categs: [9],
            tags: [11])
            
            novoPost(publicador: 10, post: 8, titulo: "The Keys to a Successful WWDC Scholarship Submission", descricao: "I found this article for us having succes in this week's competition. I hope it is helpful!", link: Link(urlString: "https://medium.com/better-programming/the-keys-to-a-successful-wwdc-scholarship-submission-8cbbf5eb2281"), categs: [6], tags: [13])
            
            //MARK: - COMENTARIOS ORIGINAIS
            //POST 2
            novoComentario(id: 1, publicador: 1, post: 2, conteudo: "I thought that radius meant radio in portuguese", is_question: false)
            novoComentario(id: 2, publicador: 2, post: 2, conteudo: "It is a false cognate!", is_question: false)
            novoComentario(id: 3, publicador: 3, post: 2, conteudo: "Interesting, I will keep in touch with this subject. I have to learn more about it.", is_question: false)
            novoComentario(id: 4, publicador: 4, post: 2, conteudo: "I didn't understand what aligment means", is_question: true)
            
            //POST 8
            novoComentario(id: 5, publicador: 1, post: 8, conteudo: "Lesson of the week: creativity > complexity!", is_question: false)
            novoComentario(id: 6, publicador: 2, post: 8, conteudo: "Interesting, i was going through the work path", is_question: false)
            novoComentario(id: 7, publicador: 3, post: 8, conteudo: "Thank you for sharing it, I was having issues!", is_question: false)
            novoComentario(id: 8, publicador: 1, post: 8, conteudo: "I'm not using SpriteKit as he. Is it bad?", is_question: true)
            
            //MARK: - ASSINATURAS
            novaAssinatura(membro: 1, categoria: 1)
            novaAssinatura(membro: 1, categoria: 2)
            novaAssinatura(membro: 1, categoria: 4)
            novaAssinatura(membro: 2, categoria: 1)
            novaAssinatura(membro: 2, categoria: 3)
            novaAssinatura(membro: 3, categoria: 2)
            novaAssinatura(membro: 3, categoria: 3)
            novaAssinatura(membro: 3, categoria: 6)
            novaAssinatura(membro: 3, categoria: 7)
            novaAssinatura(membro: 3, categoria: 5)
            novaAssinatura(membro: 5, categoria: 5)
            
            //MARK: - POSTS SALVOS
            salvaPost(membro: 3, post: 8)
            salvaPost(membro: 3, post: 3)
            salvaPost(membro: 3, post: 6)
            
            
        } // if self.id
    } // init()
    
    //MARK: - FUNCOES GET
    func getMembro(id: Int) -> Membro? {
        for membro in self.membros {
            if (id == membro.usuario.id) { return membro }
        }
        return nil
    }
    
    func getCategoria(id: Int) -> Categoria? {
        for categ in self.categorias {
            if (id == categ.id) { return categ }
        }
        return nil
    }
    
    func getCategorias(ids: [Int]) -> [Categoria] {
        var categorias: [Categoria] = []
        for id in ids {
            for categ in self.categorias {
                if (id == categ.id) { categorias.append(categ) }
            }
        }
        return categorias
    }
    
    func getTag(id: Int) -> Tag? {
        for tag in self.tags {
            if (id == tag.id) { return tag }
        }
        return nil
    }
    
    func getTags(ids: [Int]) -> [Tag] {
        var tags: [Tag] = []
        for id in ids {
            for tag in self.tags {
                if (id == tag.id) { tags.append(tag) }
            }
        }
        return tags
    }
    
    func getPost(id: Int) -> Post? {
        for post in self.posts {
            if (id == post.id) { return post }
        }
        return nil
    }
    
    func getPostsByCategorie(categ: Int) -> [Post] {
        var posts: [Post] = []
        
        for post in self.posts {
            for cat in post.categorias {
                if cat.id == categ {
                    posts.append(post)
                }
            }
        }
        
        return posts
    }
    
    func getPostsByTag(tag id_tag: Int) -> [Post] {
        var posts: [Post] = []
        
        for post in self.posts {
            for tag in post.tags {
                if tag.id == id_tag {
                    posts.append(post)
                }
            }
        }
        
        return posts
    }
    
    //MARK: - NOVOS OBJETOS
    func novoMembro(id id_membro: Int, is_admin: Bool) {
        if let usuario = DAO().getUsuario(id: id_membro) {
            if getMembro(id: usuario.id) == nil { //para nao adicionar membro repetido
                let membro = Membro(usuario: usuario, sala: self, is_admin: is_admin)
                self.membros.append(membro)
                if is_admin { self.admins.append(membro) }
            }
        }
        else {
            print("Membro não adicionado à sala \(self.nome) pois Usuário não existe")
        }
    }
    
    func novaCategoria(id: Int, nome: String) {
        self.categorias.append(Categoria(id: id, nome: nome))
    }
    
    func novaTag(id: Int, nome: String, categs: [Int]) {
        let categorias = getCategorias(ids: categs)
        let tag = Tag(id: id, nome: nome, categorias: categorias)
        
        self.tags.append(tag)
        for categ in categorias {
            categ.addTag(tag: tag)
        }// Todas as categorias as quais uma tag pertencer terao ela nas suas listas de tags
    }
    
    func novoPost(publicador id_membro: Int, post id_post: Int, titulo: String, descricao: String?, link: Link?, categs: [Int], tags: [Int]) {
        let membro = getMembro(id: id_membro)
        let categorias = getCategorias(ids: categs)
        let tags = getTags(ids: tags)
        
        if membro != nil {
            if categorias.count != 0 {
                let post = Post(id: id_post, titulo: titulo, descricao: descricao, link: link, categs: categorias, tags: tags, publicador: membro!)
                
                self.posts.append(post)
                membro?.publicaPost(post: post)
                // Quando uma publicacao eh feita ela vai para a lista de publicacoes do membro, para a lista de posts daquelas categorias e tags
                for categ in categorias {
                    categ.addPost(post: post)
                }
                for tag in tags {
                    tag.addPost(post: post)
                }
                print("Criou o post!")
            }
            else {
                print("Impossível criar o post pois nenhuma categoria é válida")
            }
        }
        else {
            print("Impossível criar o post pois o membro publicador não existe")
        }
        
    }
    
    //MARK: - RELACIONAMENTOS
    func novoComentario(id: Int, publicador id_publicador: Int, post id_post: Int, conteudo: String, is_question: Bool) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post)  {
            post.novoComentario(id: id, publicador: publicador, conteudo: conteudo, is_question: is_question)
        }
        else {
            print("Comentário não adicionado por publicador não identificado")
        }
    }
    
    func novoReply(id: Int, publicador id_publicador: Int, post id_post: Int, conteudo: String, original id_original: Int) {
        if let publicador = getMembro(id: id_publicador), let post = getPost(id: id_post) {
            post.novoReply(id: id, publicador: publicador, conteudo: conteudo, original: id_original)
        }
        else {
            print("Comentário não adicionado por publicador ou post não identificado")
        }
    }
    
    func novaAssinatura(membro id_membro: Int, categoria: Int) {
        let membro = getMembro(id: id_membro)
        let categ = getCategoria(id: categoria)
        
        membro?.assinaCategoria(categoria: categ)
        categ?.addAssinantes(membro: membro)
    }
    
    func salvaPost(membro id_membro: Int, post id_post: Int) {
        let membro = getMembro(id: id_membro)
        let post = getPost(id: id_post)
        
        membro?.salvaPost(post: post)
    }
    
}
