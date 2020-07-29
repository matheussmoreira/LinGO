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
    //let link_model = LinkModel()
    let id = UUID()
    var nome: String = "Sala 1"
    var usuarios: [Usuario] = []
    var posts: [Post] = []
    var categorias: [Categoria] = []
    var tags: [Tag] = []
    
    init() {
        /* ************************************ USUARIOS ************************************* */
        self.usuarios.append(Usuario(id: 1, email: "matheus@boladao.com", senha: "sucoDeAbacaxi", nome: "Matheus Moreira", foto_perfil: "foto_matheus", pais: "USA", fluencia_ingles: "Intermediate", is_admin: true))
        self.usuarios.append(Usuario(id: 2, email: "victor@boladao.com", senha: "niteroiAmorzinho", nome: "Victor Duarte", foto_perfil: "foto_victor", pais: "Spain", fluencia_ingles: "Advanced", is_admin: false))
        self.usuarios.append(Usuario(id: 3, email: "evelyn@boladona.com", senha: "roxoComAmarelo", nome: "Evelyn de Jesus", foto_perfil: "foto_evelyn", pais: "Brazil", fluencia_ingles: "Basic", is_admin: true))
        self.usuarios.append(Usuario(id: 4, email: "leonardo@boladao.com", senha: "monalisa", nome: "Leonardo da Vinci", foto_perfil: "foto_leo", pais: "Italy", fluencia_ingles: "Zero", is_admin: false))
        self.usuarios.append(Usuario(id: 5, email: "michelle@boladona.com", senha: "democracia", nome: "Michelle Obama", foto_perfil: "foto_michelle", pais: "USA", fluencia_ingles: "Advanced", is_admin: false))
        
        /* ************************************ POSTS *************************************** */
        publicacao(usuario: 2, post: 1, titulo: "Stop obsessing over user personas", descricao: "People don’t need your product because they belong to a stupid persona", link: nil)
        publicacao(usuario: 2, post: 2, titulo: "Geometry in UI Design", descricao: "Because automatic alignment sometimes just doesn’t work", link: nil)
        publicacao(usuario: 1, post: 3, titulo: "The Mistakes I Made As a Beginner Programmer", descricao: "Learn to identify them, make habits to avoid them", link: nil)
        publicacao(usuario: 3, post: 4, titulo: "SwiftUI: a new perception of developing", descricao: "This article is not intended to be a simplifying way to say that programming is “easy”. Of course there are many notions and concepts to learn but with the right motivation and with the right tools nothing is impossible. However, it can be said that with SwiftUI, everyone can program in a easier way. It is not important what your background is but the goals you want to achieve and your motivation", link: nil)
        publicacao(usuario: 3, post: 5, titulo: "The 10 Qualities of an Emotionally Intelligent Person", descricao: nil, link: nil)
        publicacao(usuario: 3, post: 6, titulo: "6 Principles Of Visual Accessibility Design", descricao: "According to the World Health Organization, 285 million people in the world are visually impaired. These 285 million people still need access to the Internet, and deserve to have access to the same information that everybody else does. Many individuals believe that if someone is visually impaired, they do not use the Internet. This is untrue.", link: nil)
        
        /* ********************************** CATEGORIAS ************************************* */
        self.categorias.append(Categoria(id: 1, nome: "Design"))
        self.categorias.append(Categoria(id: 2, nome: "Programming"))
        self.categorias.append(Categoria(id: 3, nome: "Accessibility"))
        self.categorias.append(Categoria(id: 4, nome: "Games"))
        self.categorias.append(Categoria(id: 5, nome: "Business"))
        
        /* ************************************* TAGS *************************************** */
        self.tags.append(Tag(id: 1, nome: "UX"))
        self.tags.append(Tag(id: 2, nome: "Personas"))
        self.tags.append(Tag(id: 3, nome: "Git"))
        self.tags.append(Tag(id: 4, nome: "SwiftUI"))
        self.tags.append(Tag(id: 5, nome: "JSON"))
        self.tags.append(Tag(id: 6, nome: "Colors"))
        self.tags.append(Tag(id: 7, nome: "Sound Effects"))
        self.tags.append(Tag(id: 8, nome: "Characters"))
        self.tags.append(Tag(id: 9, nome: "App Store"))
        self.tags.append(Tag(id: 10, nome: "In-App Purchases"))
        self.tags.append(Tag(id: 11, nome: "Self-knowledge"))
        self.tags.append(Tag(id: 12, nome: "Visual Accessibility"))
        
        /* ***************************** ADOÇÃO TAGS-CATEGORIAS ******************************* */
        addTagCategoria(tag: 1, categoria: 1);  addTagCategoria(tag: 2, categoria: 1)
        addTagCategoria(tag: 3, categoria: 2);  addTagCategoria(tag: 4, categoria: 1)
        addTagCategoria(tag: 4, categoria: 2);  addTagCategoria(tag: 5, categoria: 2)
        addTagCategoria(tag: 6, categoria: 1);  addTagCategoria(tag: 6, categoria: 3)
        addTagCategoria(tag: 7, categoria: 3);  addTagCategoria(tag: 7, categoria: 4)
        addTagCategoria(tag: 8, categoria: 4);  addTagCategoria(tag: 9, categoria: 5)
        addTagCategoria(tag: 10, categoria: 5); addTagCategoria(tag: 11, categoria: 5)
        addTagCategoria(tag: 12, categoria: 1); addTagCategoria(tag: 12, categoria: 3)
        
        /* *************************** ADOÇÃO CATEGORIAS-POSTS******************************** */
        addCategoriaPost(categoria: 1, post: 1); addCategoriaPost(categoria: 1, post: 2)
        addCategoriaPost(categoria: 2, post: 3); addCategoriaPost(categoria: 1, post: 4)
        addCategoriaPost(categoria: 2, post: 4); addCategoriaPost(categoria: 5, post: 5)
        addCategoriaPost(categoria: 1, post: 6); addCategoriaPost(categoria: 3, post: 6)

        /* ***************************** ADOÇÃO TAGS-POSTS *********************************** */
        addTagPost(tag: 1, post: 1);  addTagPost(tag: 1, post: 2)
        addTagPost(tag: 2, post: 1);  addTagPost(tag: 4, post: 4)
        addTagPost(tag: 11, post: 5); addTagPost(tag: 12, post: 6)
        
        /* ******************************** POSTS SALVOS ************************************ */
        
        /* ********************************** ASSINATURAS ************************************ */
        assinatura(usuario: 1, categoria: 1)
        assinatura(usuario: 1, categoria: 2)
        assinatura(usuario: 1, categoria: 4)
        assinatura(usuario: 2, categoria: 1)
        assinatura(usuario: 2, categoria: 3)
        assinatura(usuario: 3, categoria: 2)
        assinatura(usuario: 3, categoria: 3)
        assinatura(usuario: 5, categoria: 3)
        assinatura(usuario: 5, categoria: 5)
        
        /* ************************************* LINKS ***************************************** */
        insereLink(url: "https://uxdesign.cc/stop-obsessing-over-user-personas-b2792ca00c7f", post: 1)
        insereLink(url: "https://medium.com/design-notes/geometry-in-ui-design-61ef4f88218a", post: 2)
        insereLink(url: "https://medium.com/edge-coders/the-mistakes-i-made-as-a-beginner-programmer-ac8b3e54c312", post: 3)
        insereLink(url: "https://medium.com/apple-developer-academy-federico-ii/swiftui-a-new-perception-of-developing-780906ee492a", post: 4)
        insereLink(url: "https://medium.com/personal-growth/the-10-qualities-of-an-emotionally-intelligent-person-f595440af4fb", post: 5)
        insereLink(url: "https://usabilitygeek.com/6-principles-visual-accessibility-design/", post: 6)
        
    } // init()
    
    /* ********************************** FUNCOES GET **************************************** */
    func getTag(id: Int) -> Tag? {
        for tag in self.tags {
            if (id == tag.id) { return tag }
        }
        return nil
    }
    
    func getCategoria(id: Int) -> Categoria? {
        for categ in self.categorias {
            if (id == categ.id) { return categ }
        }
        return nil
    }
    
    func getPost(id: Int) -> Post? {
        for post in self.posts {
            if (id == post.id) { return post }
        }
        return nil
    }
    
    func getUsuario(id: Int) -> Usuario? {
        for user in self.usuarios {
            if (id == user.id) { return user }
        }
        return nil
    }
    
    /* ******************************* RELACIONAMENTOS *************************************** */
    
    func addTagCategoria(tag id_tag: Int, categoria: Int) {
        let tag = getTag(id: id_tag)
        let categ = getCategoria(id: categoria)
        
        tag?.addCategoria(categoria: categ)
        categ?.addTag(tag: tag)
    } // Quando uma tag pertence a uma categoria, aquela categoria ganha essa tag
    
    func addTagPost(tag id_tag: Int, post id_post: Int) {
        let tag = getTag(id: id_tag)
        let post = getPost(id: id_post)
        
        tag?.addPost(post: post)
        post?.addTag(tag: tag)
    } // Quando um post tem uma tag, aquela tag ganha esse post
    
    func addCategoriaPost(categoria: Int, post id_post: Int) {
        let categ = getCategoria(id: categoria)
        let post = getPost(id: id_post)
        
        categ?.addPost(post: post)
        post?.addCategoria(categoria: categ)
    } // Quando um post tem uma categoria, aquela categoria ganha essa post
    
    func publicacao(usuario: Int, post id_post: Int, titulo: String, descricao: String?, link: Link?/*, improprio: Bool*/) {
        let user = getUsuario(id: usuario)
        let post = Post(id: id_post, titulo: titulo, descricao: descricao, link: link, publicador: user!/*, improprio: improprio*/)
        
        self.posts.append(post)
        user?.publicaPost(post: post)
    } // Quando uma publicacao eh feita ela vai para a lista de publicacoes do publicador
    
    func assinatura(usuario: Int, categoria: Int) {
        let user = getUsuario(id: usuario)
        let categ = getCategoria(id: categoria)
        
        user?.assinaCategoria(categoria: categ)
        categ?.addAssinantes(usuario: user)
    } // Lista de assinaturas do usuario e de assinantes da categoria
    
    func salvaPost(usuario: Int, post id_post: Int) {
        let user = getUsuario(id: usuario)
        let post = getPost(id: id_post)
        
        user?.salvaPost(post: post)
    }
    
    /* ******************************** OUTRAS FUNCOES *************************************** */
    
    func insereLink(url: String, post id_post: Int) {
        let post = getPost(id: id_post)
        LinkModel.fetchMetadata(for: url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let metadata):
                    print("Case success")
                    post?.addLink(link: LinkModel.createLink(metadata: metadata))
                    //post?.debug()
                case .failure(let error):
                    print("Case failure")
                    print(error.localizedDescription)
                }
            } // DispatchQueue
        } // fetch
    } // insereLink
    
}
