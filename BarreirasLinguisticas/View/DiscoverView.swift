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
    @State private var recentPosts: [Post] = []
    @State private var mensagem = ""
    @State private var showPostEditor = false
    @State private var showRooms = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                //MARK: -  SCROLL HORIZONTAL DE CIMA
                if fyPosts.isEmpty {
                    VStack {
                        Text("No posts for you 😕")
                            .foregroundColor(Color.gray)
                        Text("\nSubscribe in a category")
                            .foregroundColor(Color.gray)
                        Text("or wait for a new post!")
                            .foregroundColor(Color.gray)
                        
                    }
                    .frame(height: 260)
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1){
                            ForEach(fyPosts.suffix(7).reversed()){ post in
                                CardsView(post: post, sala: self.sala)
                                    .environmentObject(self.membro)
                            }
                        }
                    }
                }
                
                //MARK: - SCROLL HORIZONTAL DE BAIXO
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
                
                if recentPosts.isEmpty {
                    VStack {
                        Text("No recent posts 😕")
                            .foregroundColor(Color.gray)
                    }.frame(height: 260)
                }
                else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1){
                            ForEach(recentPosts.suffix(7).reversed()){ post in
                                CardsView(post: post, sala: self.sala)
                                    .environmentObject(self.membro)
                            }
                        }
                    }
                }
            }
            .onAppear {
//                print(membro.id)
                self.loadFY()
                self.loadRecentPosts()
            }
            .navigationBarTitle("Discover")
            .navigationBarItems(
//                leading:
//                    Button(action: {self.showRooms.toggle()}) {
//                        Image(systemName: "rectangle.grid.1x2")
//                            .imageScale(.large)
//                            .foregroundColor(LingoColors.lingoBlue)
//                    }
//                    .sheet(isPresented: $showRooms, onDismiss: {
//                        self.loadFY()
//                        self.loadRecentPosts()
//                    }) {
//                        RoomsView(usuario: self.membro.usuario)
//                            .environmentObject(self.dao)
//                    },
                trailing:
                    HStack {
                        Spacer()
//                        Image(systemName: "magnifyingglass")
//                            .imageScale(.large)
//                            .foregroundColor(LingoColors.lingoBlue)
                        Button(action: {self.showPostEditor.toggle()}) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .foregroundColor(LingoColors.lingoBlue)
                                .padding(.leading)
                        }
                        .sheet(isPresented: $showPostEditor) {
                            PostCreatorView()
                                .environmentObject(self.membro)
                                .environmentObject(self.sala)
                                .environmentObject(self.dao)
                        }
                    })
        }
    } //body
    
    func loadFY() {
        fyPosts = []
        for assinatura in membro.assinaturas {
            fyPosts.append(
                contentsOf: sala.getPostsByCategorie(categ: assinatura)
            )
        }
    }
    
    func loadRecentPosts() {
        recentPosts = []
        recentPosts.append(
            contentsOf: sala.posts.filter({!fyPosts.contains($0)})
        )
    }
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoverView().environmentObject(dao.salas[0].membros[0])
//    }
//}

struct CardsView: View {
    @ObservedObject var post: Post
    @EnvironmentObject var membro: Membro
    @ObservedObject var sala: Sala
    
    var body: some View {
        //GeometryReader { geometry in
        NavigationLink(destination: PostView(sala: sala, post: self.post).environmentObject(self.membro)) {
            PostCardView(post: self.post, sala: sala, width: 0.80)
                .frame(width: UIScreen.width-30)
            //.rotation3DEffect(Angle(degrees: Double(geometry.frame(in:.global).minX)-40) / -20, axis: (x: 0, y: 10.0, z: 0))
        }
        //}
        //.frame(width: UIScreen.width, height: 270)
    }
}
