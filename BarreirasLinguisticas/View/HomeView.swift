//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sala: Sala
    @ObservedObject var membro: Membro
    var cardFrame: CGFloat = 410.0
    var fyPosts : [Post] { return sala.posts } // mudar para assinaturas
    var recentPosts: [Post] { return sala.posts } // mudar para base na data
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            //TOPICO DOS FOR YOU
            HStack {
                Text("For you")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .padding(.top, 50)
                Spacer()
            }
            
            SearchBarView(mensagem: "Search for all posts")
            
            //POSTS FOR YOU
            if fyPosts.count == 0 {
                VStack {
                    Spacer()
                    Text("No posts for you :(")
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 20){
                        ForEach(fyPosts){ post in
                            NavigationLink(destination: PostView(post: post)) {
                                PostCardView(post: post)
                                    .frame(width: self.cardFrame)
                            }
                        }
                    }
                }
            } //else
            
            //TOPICO DOS RECENT POSTS
            HStack {
                Text("Recent posts")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            //RECENT POSTS
            if recentPosts.count == 0 {
                VStack {
                    Spacer()
                    Text("No recent posts :(")
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(sala.posts){ post in
                            NavigationLink(destination: PostView(post: post)) {
                                PostCardView(post: post)
                                    .frame(width: self.cardFrame)
                            }
                        }
                    }
                } //ScrollView
            } //else
            
            //TOPICO DAS NEW TAGS
            HStack {
                Text("New tags")
                    .font(.callout)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            //NEW TAGS
            if sala.tags.count == 0 {
                Text("No new tags :(")
                    .foregroundColor(Color.gray)
            }
            else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(sala.tags) { tag in
                            NewTagsView(nome: tag.nome)
                                .padding(.leading)
                        }
                    }
                }
            } //else
        } //VStack
    } //body
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sala: DAO().salas[0], membro: DAO().salas[0].membros[0])
    }
}
