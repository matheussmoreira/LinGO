//
//  MySavedPosts.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct MySavedPosts: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var sala: Sala
    private var loaded_posts: [Post] {
        var salvos: [Post] = []
        for s in self.membro.idsPostsSalvos {
            if let postSalvo = sala.getPost(id: s) {
                salvos.append(postSalvo)
            }
        }
        return salvos
    }
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            if membro.idsPostsSalvos.isEmpty {
                Spacer()
                Text("You haven't saved any post yet 😕")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    if loaded_posts.isEmpty {
                        // Nenhum post publicado ainda foi baixado
                        VStack {
                            ProgressView("")
                        }.frame(height: 260)
                    } else {
                        VStack {
                            ForEach(self.loaded_posts.reversed()) { post in
                                NavigationLink(
                                    destination: PostView(sala: self.sala, post: post)
                                        .environmentObject(self.membro)
                                ){
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
        }
        .navigationBarTitle("Your saved posts")
//        .onAppear {
//            self.salvos = []
//            for i in 0..<self.membro.idsPostsSalvos.count {
//                if let postSalvo = sala.getPost(id: self.membro.idsPostsSalvos[i]) {
//                    self.salvos.append(postSalvo)
//                }
//
//            }
//        }
    } //body
}

//struct MySavedPosts_Previews: PreviewProvider {
//    static var previews: some View {
//        MySavedPosts(sala: DAO().salas[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
