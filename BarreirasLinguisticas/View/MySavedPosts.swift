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
    @State var mensagem = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Your saved posts")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            SearchBar(text: $mensagem)
            
            if membro.posts_salvos.count == 0 {
                Spacer()
                Text("You haven't saved any post yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(membro.posts_salvos.reversed()) { post in
                        NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                            PostCardImageView(post: post)
                        }
                    }
                }
            } //else
        } //VStack
    } //body
}

struct MySavedPosts_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPosts()
            .environmentObject(DAO().salas[0].membros[0])
    }
}
