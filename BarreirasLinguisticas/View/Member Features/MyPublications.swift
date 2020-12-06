//
//  MyPublications.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct MyPublications: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var sala: Sala
    @State private var mensagem = ""
    private var loaded_posts: [Post] {
        var posts: [Post] = []
        for idPublicado in membro.idsPostsPublicados {
            if let publicadoValido = sala.getPost(id: idPublicado){
                posts.append(publicadoValido)
            }
        }
        return posts
    }
    
    var body: some View {
        VStack {
            if membro.idsPostsPublicados.isEmpty {
                Spacer()
                Text("You haven't published any post yet 😕")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: true) {
                    if loaded_posts.isEmpty {
                        // Nenhum post publicado foi baixado ainda
                        VStack {
                            ProgressView("")
                        }.frame(height: 260)
                    } else {
                        VStack {
                            ForEach(loaded_posts) { post in
                                NavigationLink(
                                    destination: PostView(
                                        sala: sala,
                                        post: post
                                    )
                                        .environmentObject(self.membro)
                                ){
                                    PostCardView(
                                        post: post,
                                        sala: sala,
                                        width: 0.85
                                    )
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
        }
        .navigationBarTitle("Your publications")
    } //body
}

//struct MyPublishedPosts_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPublications(sala: DAO().salas[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
