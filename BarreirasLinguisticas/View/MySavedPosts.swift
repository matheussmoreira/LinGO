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
    @State private var salvos: [Post] = []
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            
            if self.salvos.isEmpty {
                Spacer()
                Text("You haven't saved any post yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.salvos.reversed()) { post in
                        NavigationLink(
                            destination: PostView(post: post)
                                .environmentObject(self.membro)
                        ){
                            PostCardView(post: post, width: 0.85)
                        }
                    }
                }
            } //else
        } //VStack
        .navigationBarTitle("Your saved posts")
        .navigationBarItems(
            trailing:
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(LingoColors.lingoBlue)
                        .imageScale(.large)
                })
        .onAppear {
            self.salvos = self.membro.posts_salvos
        }
    } //body
}

struct MySavedPosts_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPosts()
            .environmentObject(DAO().salas[0].membros[0])
    }
}
