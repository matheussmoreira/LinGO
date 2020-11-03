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
    
    var body: some View {
        VStack {
            if membro.posts_publicados.isEmpty {
                Spacer()
                Text("You haven't published any post yet 😕")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<membro.posts_publicados.count) { idx in
                        NavigationLink(
                            destination: PostView(sala: sala, post: sala.getPost(id: membro.posts_publicados[idx])!)
                                .environmentObject(self.membro)
                        ){
                            PostCardView(post: sala.getPost(id: membro.posts_publicados[idx])!, sala: sala, width: 0.85)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Your publications")
        .navigationBarItems(trailing:
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .imageScale(.large)
                                        .foregroundColor(LingoColors.lingoBlue)
                                })
    } //body
}

//struct MyPublishedPosts_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPublications(sala: DAO().salas[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
