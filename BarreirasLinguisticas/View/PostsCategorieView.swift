//
//  PostsCategorieView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostsCategorieView: View {
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @ObservedObject var categoria: Categoria
    @ObservedObject var sala: Sala //{ return dao.sala_atual! }
    @State private var postSelectionado: Post?
    @State private var subscribed = false
    @State private var subscribedImage = "checkmark.circle"
    @State private var loaded_posts: [Post] = []
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            
            if loaded_posts.isEmpty {
                Spacer()
                Text("No posts in \(categoria.nome) :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(loaded_posts) { post in
                        NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                            PostCardImageView(post: post, proportion: 0.85)
                        }
                    }
                }
            } //else
        }//VStack
            .navigationBarTitle(categoria.nome)
            .navigationBarItems(trailing:
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                        .foregroundColor(LingoColors.lingoBlue)
                    Button(action:{self.changeSubscription()}){
                        Image(systemName: subscribedImage)
                            .padding(.leading)
                            .imageScale(.large)
                            .foregroundColor(.green)
                    }
            })
            .onAppear { self.load() }
    } //body
    
    func load() {
        loaded_posts = sala.getPostsByCategorie(categ: categoria.id)
        subscribed = membro.assinaturas.contains(categoria)
        if subscribed {
            subscribedImage = "checkmark.circle.fill"
        }
        else {
            subscribedImage = "checkmark.circle"
        }
    }
    
    func changeSubscription(){
        subscribed.toggle()
        if subscribed {
            subscribedImage = "checkmark.circle.fill"
            membro.assinaCategoria(categoria: categoria)
        }
        else {
            subscribedImage = "checkmark.circle"
            membro.removeAssinatura(categoria: categoria)
        }
    }
}

struct PostsCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        PostsCategorieView(
            categoria: DAO().salas[0].categorias[0], sala: DAO().salas[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
