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
    @State private var mensagem = ""
    
    var body: some View {
        VStack {
            if membro.posts_publicados.isEmpty {
                Spacer()
                Text("You haven't published any post yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(membro.posts_publicados.reversed()) { post in
                        NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                            PostCardImageView(post: post, proportion: 0.85)
                        }
                    }
                }
            } //else
        } //VStack
        .navigationBarTitle("Your published posts")
        .navigationBarItems(trailing:
            HStack {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundColor(LingoColors.lingoBlue)
        })
    } //body
}

struct MyPublishedPosts_Previews: PreviewProvider {
    static var previews: some View {
        MyPublications().environmentObject(DAO().salas[0].membros[0])
    }
}
