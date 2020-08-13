//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @ObservedObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State var fyPosts: [Post] = []
    @State var mensagem = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("For you")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }
                
                SearchBar(text: $mensagem)
                
                ScrollView(.vertical, showsIndicators: false) {
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
                    .onAppear { self.loadFY() }
            } //VStack
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
        DiscoverView(sala: DAO().salas[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
