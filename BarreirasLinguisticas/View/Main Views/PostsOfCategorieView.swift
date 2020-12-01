//
//  PostsCategorieView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostsOfCategorieView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @ObservedObject var categoria: Categoria
    @ObservedObject var sala: Sala
    @State private var showPostEditor = false
    @State private var postSelectionado: Post?
    @State private var subscribed = false
    @State private var subscribedImage = "checkmark.circle"
    private var loaded_posts: [Post] {
        return sala.getPostsByCategorie(categ: categoria.id)
    }
    @State private var mensagem = ""
    @State private var showAlertApagaCategoria = false
    
    var body: some View {
        VStack {
            if loaded_posts.isEmpty {
                if !sala.allPostsLoaded && !sala.loadingPostsError {
                    /*
                     Nao carregou todos os posts, entao nao tem
                     como falar com certeza que eh pra mostrar a msg
                     "No posts for you"
                    */
                    VStack {
                        ProgressView("")
                    }.frame(height: 260)
                } else {
                    Spacer()
                    Text("No posts in \(categoria.nome) 😕")
                        .foregroundColor(Color.gray)
                    
                    // BOTAO PARA CRIAR NOVA CATEGORIA
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
                        isPresented: $showPostEditor//,
    //                    onDismiss: {
    //                        self.loaded_posts = self.sala.getPostsByCategorie(categ: self.categoria.id)
    //                    }
                    ){
                        PostCreatorView()
                            .environmentObject(self.membro)
                            .environmentObject(self.sala)
                            .environmentObject(self.dao)
                    }
                    Spacer()
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(loaded_posts) { post in
                            NavigationLink(
                                destination: PostView(sala: self.sala, post: post)
                                    .environmentObject(self.membro)
                            ) {
                                PostCardView(post: post, sala: sala, width: 0.85)
                            }
                        }
                        if !sala.allPostsLoaded && !sala.loadingPostsError {
                            VStack {
                                ProgressView("")
                            }.frame(height: 260)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(categoria.nome)
        .navigationBarItems(trailing:
                                HStack {
                                    if loaded_posts.isEmpty && !membro.isBlocked {
                                        Button(action:{showAlertApagaCategoria.toggle()}) {
                                            Image(systemName: "trash")
                                                .imageScale(.large)
                                                .foregroundColor(LingoColors.lingoBlue)
                                        }.alert(isPresented: $showAlertApagaCategoria) {
                                            Alert(
                                                title: Text("Delete category?"),
                                                primaryButton: .default(Text("Yes")){
                                                    apagaCategoria(categoria)
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                    } else {
                                        Button(action:{showAlertApagaCategoria.toggle()}) {
                                            Image(systemName: "trash")
                                                .imageScale(.large)
                                                .foregroundColor(LingoColors.lingoBlue)
                                        }.alert(isPresented: $showAlertApagaCategoria) {
                                            Alert(
                                                title: Text("You cannot delete a category that contains at least one post or if you are blocked"),
                                                dismissButton: .default(Text("Ok"))
                                            )
                                        }
                                    }

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
    
    func apagaCategoria(_ categ: Categoria) {
        sala.excluiCategoria(categ)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func load() {
        subscribed = membro.idsAssinaturas.contains(categoria.id)
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
            membro.assinaCategoria(categoria: categoria.id)
        }
        else {
            subscribedImage = "checkmark.circle"
            membro.removeAssinatura(categoria: categoria.id)
        }
    }
}

//struct PostsCategorieView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsOfCategorieView(
//            categoria: dao.salas[0].categorias[0], sala: dao.salas[0]).environmentObject(dao.salas[0].membros[0])
//    }
//}
