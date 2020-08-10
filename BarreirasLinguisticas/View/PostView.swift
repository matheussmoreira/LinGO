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
    @State var showComments = false
    
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
                    
                    //DESCRICAO
                    Text(post.descricao!)
                        .padding(.bottom)
                    
                    //LINK PREVIEW
                    if (stored_link != nil && stored_link?.metadata != nil) {
                        LinkView(metadata: stored_link!.metadata!)
                    }
                    
                    
                    
                } //VStack
                    .onAppear { self.carregaLink() }
            } //ScrollView
                .onAppear { self.loadBookmark() }
                .navigationBarTitle(
                    Text(post.titulo)
                        .font(.system(.title, design: .rounded)),displayMode: .automatic
                )
                .padding(.horizontal)
                .navigationBarItems(trailing:
                    Button(action: {self.changeBookmark()}){
                        Image(systemName: bookmarkedImage)
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
            )
            
            
            //IR PARA OS COMENTARIOS
            Button(action: {self.showComments.toggle()}) {
                Text("Read the comments")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
            }
            .sheet(isPresented: $showComments) {
                //COMENTARIOS OU MENSAGEM
                CommentsQuestionsToggle(comentarios: self.post.comentarios).environmentObject(self.membro)
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
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
