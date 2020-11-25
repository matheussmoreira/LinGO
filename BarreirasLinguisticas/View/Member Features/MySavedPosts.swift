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
    @State private var salvos: [Post] = []
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            
            if self.salvos.isEmpty {
                Spacer()
                Text("You haven't saved any post yet 😕")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.salvos.reversed()) { post in
                        NavigationLink(
                            destination: PostView(sala: self.sala, post: post)
                                .environmentObject(self.membro)
                        ){
                            PostCardView(post: post, sala: sala, width: 0.85)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Your saved posts")
//        .navigationBarItems(
//            trailing:
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(LingoColors.lingoBlue)
//                        .imageScale(.large)
//                })
        .onAppear {
            for i in 0..<self.membro.idsPostsSalvos.count {
                if let postSalvo = sala.getPost(id: self.membro.idsPostsSalvos[i]) {
                    self.salvos.append(postSalvo)
                }
                
            }
        }
    } //body
}

//struct MySavedPosts_Previews: PreviewProvider {
//    static var previews: some View {
//        MySavedPosts(sala: DAO().salas[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
