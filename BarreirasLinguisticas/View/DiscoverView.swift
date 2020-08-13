//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    var sala: Sala { return dao.sala_atual! }
    @State private var fyPosts: [Post] = []
    @State private var mensagem = ""
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("For you")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }
                //MARK: - SUBSCRIPTION POSTS
                
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
                            ForEach(fyPosts.reversed()){ post in
                                NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                                    PostCardImageView(post: post)
                                        .frame(width: UIScreen.width)
                                }
                                /* EFEITO 3D
                                 GeometryReader { geometry in
                                 NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                                 PostCardImageView(post: post)
                                 .frame(width: UIScreen.width)
                                 .rotation3DEffect(Angle(degrees: Double(geometry.frame(in:.global).minX)-40) / -20, axis: (x: 0, y: 10.0, z: 0))
                                 }
                                 }.frame(width: UIScreen.width, height: 270)
                                 */
                            }
                        }
                    } //ScrollView
                } //else
                
                //MARK: - RECENT POSTS
                HStack {
                    Text("Recent posts")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                }
                
                if sala.posts.count == 0 {
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
                            ForEach(sala.posts/*.reversed()*/){ post in
                                NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                                    PostCardImageView(post: post)
                                        .frame(width: UIScreen.width)
                                }
                            }
                        }
                    } //ScrollView
                } //else
            } //ScrollView
                .onAppear { self.loadFY() }
                .navigationBarTitle("Discover")
                .navigationBarItems(trailing:
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding(.leading)
                        
                })
        } //NavigationView
    } //body
    
    func loadFY() {
        for categ in membro.assinaturas {
            for post in sala.getPostsByCategorie(categ: categ.id) {
                if !fyPosts.contains(post) {
                    fyPosts.append(post)
                }
            }
        }
    } //loadFY
    
}

//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(/*sala: DAO().salas[0]*/).environmentObject(DAO().salas[0].membros[0])
    }
}
