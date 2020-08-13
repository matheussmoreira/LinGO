//
//  PostView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 01/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import LinkPresentation

struct PostView: View {
    @ObservedObject var post: Post
    @EnvironmentObject var membro: Membro
    @State private var stored_link: Link?
    @State private var bookmarked = false
    @State private var bookmarkedImage = "bookmark"
    @State private var showComments = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading){
                    
                    //AUTOR E NIVEL DE FLUENCIA
                    HStack {
                        Text("Shared by \(post.publicador.usuario.nome)")
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("English Level:")
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .foregroundColor(post.publicador.usuario.cor_fluencia)
                    }
                    
                    //TAGS
                    HStack{
                        ForEach(post.tags) { tag in
                            Text("#\(tag.nome)")
                                .foregroundColor(Color.blue)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    //DESCRICAO
                    Text(post.descricao!)
                        .padding(.bottom)
                    
                    //LINK PREVIEW
                    if (stored_link != nil && stored_link?.metadata != nil) {
                        LinkView(metadata: stored_link!.metadata!)
                    }
                    
                } //VStack
            } //ScrollView
                .frame(width: UIScreen.width*0.95)
                .onAppear {
                    self.carregaLink()
                    self.loadBookmark()
            }
            .navigationBarTitle(
                Text(post.titulo)
                    .font(.system(.title, design: .rounded)),displayMode: .automatic
            )
                .padding(.horizontal)
                .navigationBarItems(trailing:
                    Button(action: {self.changeBookmark()}){
                        Image(systemName: bookmarkedImage)
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
            )
            
            //MARK: - REPORT E COMENTARIOS
            HStack {
                ZStack {
                    Capsule()
                        .frame(width: 100.0, height: 50.0)
                        .foregroundColor(.orange)
                    Button("Report") {
                        self.report()
                    }
                    .foregroundColor(.white)
                }
                .padding(.all)
                .foregroundColor(.red)
                Spacer()
                
                Button(action: {self.showComments.toggle()}) {
                    ZStack {
                        Capsule()
                            .frame(height: 50.0)
                            .foregroundColor(.blue)
                        HStack {
                            Spacer()
                            Text("Ask or Comment")
                                .foregroundColor(.white)
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .padding(.all)
                .sheet(isPresented: $showComments) {
                    CommentsQuestionsToggle(post: self.post)
                        .environmentObject(self.membro)
                }
            } //sheet
        } //VStack
    } //body
    
    func carregaLink(){
        if let link = post.link {
            //stored_link = post.link
            stored_link = Link.loadLink(link.id) // do cache
        }
    }
    
    func loadBookmark() {
        bookmarked = membro.posts_salvos.contains(post)
        if bookmarked {
            bookmarkedImage = "bookmark.fill"
        }
        else {
            bookmarkedImage = "bookmark"
        }
    }
    
    func changeBookmark(){
        bookmarked.toggle()
        if bookmarked {
            bookmarkedImage = "bookmark.fill"
            membro.salvaPost(post: post)
        }
        else {
            bookmarkedImage = "bookmark"
            membro.removePostSalvo(post: post)
        }
    }
    
    func report() {
    }
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
