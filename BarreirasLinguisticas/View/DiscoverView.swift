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
    @EnvironmentObject var sala: Sala
    @State private var fyPosts: [Post] = []
    @State private var mensagem = ""
    @State private var showPostEditor = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
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
                        HStack {
                            ForEach(fyPosts.reversed()){ post in
                                Cards3D(post: post, membro: self.membro)
                            }
                        } //HStack
                    } //ScrollView
                } //else
                
                //MARK: - RECENT POSTS
                HStack {
                    Text("Recent posts")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .padding(.top)
                        .foregroundColor(.primary)
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
                        HStack {
                            ForEach(sala.posts/*.reversed()*/){ post in
                                Cards3D(post: post, membro: self.membro)
                            }
                        }
                    } //ScrollView
                } //else
            } //ScrollView Vertical
                .onAppear { self.loadFY() }
                .navigationBarTitle("Discover")
                .navigationBarItems(trailing:
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .foregroundColor(LingoColors.lingoBlue)
                        Button(action: {self.showPostEditor.toggle()}) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .foregroundColor(LingoColors.lingoBlue)
                                .padding(.leading)
                        }
                        .sheet(isPresented: $showPostEditor) {
                            PostEditorView().environmentObject(self.membro).environmentObject(self.dao)
                        }
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView().environmentObject(DAO().salas[0].membros[0])
    }
}

struct Cards3D: View {
    @ObservedObject var post: Post
    @ObservedObject var membro: Membro
    
    var body: some View {
        //GeometryReader { geometry in
            NavigationLink(destination: PostView(post: self.post).environmentObject(self.membro)) {
                PostCardImageView(post: self.post)
                    .frame(width: UIScreen.width)
                    //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in:.global).minX)-40) / -20, axis: (x: 0, y: 10.0, z: 0))
            }
        //}
        //.frame(width: UIScreen.width, height: 270)
    }
}
