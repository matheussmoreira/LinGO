//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dao: DAO
    private var allPosts : [Post] { return DAO().posts }
    private var recentPosts: [Post] { return DAO().posts }
    // mudar o recentPosts para os recentes com base na data!!
    
    var body: some View {
        VStack {
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
            if allPosts.count == 0 {
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
                        ForEach(allPosts){ post in
                            Button(action: { print("Clicou!") }, label: { FYCardView(post: post)
                            })
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
                    Text("No recent posts for you :(")
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(dao.posts){ post in
                            Button(action: { print("Clicou!") },label: { RecentsView(post: post)
                            })
                        }
                    }
                }
            }
            
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
            
            Spacer()
        } //VStack
    } //body
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
