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
    @State var fyPosts: [Post] = []//{ return sala.posts } // mudar para assinaturas
    var recentPosts: [Post] { return sala.posts } // mudar para base na data
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            //MARK: - TOPICO DOS FOR YOU
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
            
            //FOR YOU CARDS
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
                                PostCardImageView(post: post)
                                    .frame(width: UIScreen.width)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                } //ScrollView
            } //else
            
            //MARK: - TOPICO DOS RECENT POSTS
            HStack {
                Text("Recent posts")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            //RECENT POSTS CARDS
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
                                    .frame(width: UIScreen.width)
                            }
                        }
                    }
                } //ScrollView
            } //else
            
            //MARK: - TOPICO DAS NEW TAGS
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
                            RoundedRectangle(cornerRadius: 45)
                            .fill(Color.blue)
                            .frame(height: 40)
                            .frame(width: 200)
                            .padding(.all)
                            .overlay(
                                Text(tag.nome)
                                    .foregroundColor(.white)
                                    .padding(.all)
                            )
                        }
                    }
                } //ScrollView
            } //else
            
        } //ScrollView
        .onAppear { self.loadFY() }
    } //body
    
    func loadFY() {
        for categ in membro.assinaturas {
            for post in sala.getPostsByCategorie(categ: categ.id) {
                if !fyPosts.contains(post) {
                    fyPosts.append(post)
                }
            }
        }
    }
}

//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(sala: DAO().salas[0], membro: DAO().salas[0].membros[0])
    }
}
