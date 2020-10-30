//
//  PostsCategorieView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostsOfCategorieView: View {
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @ObservedObject var categoria: Categoria
    @ObservedObject var sala: Sala
    @State private var showPostEditor = false
    @State private var postSelectionado: Post?
    @State private var subscribed = false
    @State private var subscribedImage = "checkmark.circle"
    @State private var loaded_posts: [Post] = []
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            if loaded_posts.isEmpty {
                Spacer()
                Text("No posts in \(categoria.nome) 😕")
                    .foregroundColor(Color.gray)
                
                Button(action: {
                    self.showPostEditor.toggle()
                }){
                    ZStack{
                        Capsule()
                            .frame(width: 250.0, height: 50.0)
                            .foregroundColor(LingoColors.lingoBlue)
                        
                        Text("Create a new one!")
                            .foregroundColor(.white)
                    }
                    
                }
                .sheet(
                    isPresented: $showPostEditor,
                    onDismiss: {
                        self.loaded_posts = self.sala.getPostsByCategorie(categ: self.categoria.id)
                    }){
                    PostCreatorView()
                        .environmentObject(self.membro)
                        .environmentObject(self.sala)
                        .environmentObject(self.dao)
                }
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(loaded_posts) { post in
                        NavigationLink(
                            destination: PostView(sala: self.sala, post: post)
                                .environmentObject(self.membro)
                        ) {
                            PostCardView(post: post, width: 0.85)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(categoria.nome)
        .navigationBarItems(trailing:
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .imageScale(.large)
                                        .foregroundColor(LingoColors.lingoBlue)
                                    
                                    Button(action:{
                                        self.changeSubscription()
                                    }){
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
        PostsOfCategorieView(
            categoria: dao.salas[0].categorias[0], sala: dao.salas[0]).environmentObject(dao.salas[0].membros[0])
    }
}
