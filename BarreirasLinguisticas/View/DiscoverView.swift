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
    @State private var showPostEditor = false
    
    var body: some View {
        NavigationView {
            VStack {
                //SearchBar(text: $mensagem)
                
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
                                /*NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                                    PostCardImageView(post: post)
                                    .frame(width: UIScreen.width)
                                    .rotation3DEffect(Angle(degrees: Double(geometry.frame(in:.global).minX)-40) / -20, axis: (x: 0, y: 10.0, z: 0))
                                    }
                                    }.frame(width: UIScreen.width, height: 270)
                                    
                                }*/
                                GeometryReader { geometry in
                                NavigationLink(destination: PostView(post: post).environmentObject(self.membro)) {
                                PostCardImageView(post: post)
                                .frame(width: UIScreen.width)
                                .rotation3DEffect(Angle(degrees: Double(geometry.frame(in:.global).minX)-40) / -20, axis: (x: 0, y: 10.0, z: 0))
                                }
                                }.frame(width: UIScreen.width, height: 270)
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
                    
                    //MARK: - NEW TAGS
                    /*HStack {
                     Text("New tags")
                     .font(.system(.title, design: .rounded))                        .fontWeight(.bold)
                     .multilineTextAlignment(.leading)
                     .padding(.leading)
                     Spacer()
                     }
                     
                     if sala.tags.count == 0 {
                     Text("No new tags :(")
                     .foregroundColor(Color.gray)
                     }
                     else {
                     ScrollView(.horizontal, showsIndicators: false) {
                     HStack {
                     ForEach(sala.tags) { tag in
                     RoundedRectangle(cornerRadius: 45)
                     .fill(LingoColors.lingoBlue)
                     .frame(width: 200, height: 40)
                     .padding(.all)
                     .overlay(
                     Text(tag.nome)
                     .foregroundColor(.white)
                     .padding(.all)
                     )
                     }
                     }
                     } //ScrollView
                     } //else*/
                } //ScrollView
            } //VStack
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

//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(/*sala: DAO().salas[0]*/).environmentObject(DAO().salas[0].membros[0])
    }
}
