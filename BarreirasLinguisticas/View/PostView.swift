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
    @ObservedObject var membro: Membro
    @State var stored_link: Link?
    @State var showComments = false
    @State var bookmarked = false
    @State var bookmarkImage = "bookmark"
    
    var body: some View {
        
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
                
                //IR PARA OS COMENTARIOS
                Button(action: {self.showComments.toggle()}) {
                    Text("Read the comments")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                }
                .sheet(isPresented: $showComments) {
                    //COMENTARIOS OU MENSAGEM
                    if (self.post.comentarios.count == 0) {
                        Text("No comments for this post :(")
                            .foregroundColor(.gray)
                    }
                    else {
                        CommentsQuestionsToggle(membro: self.membro, comentarios: self.post.comentarios)
                    } //else
                } //sheet
                
            } //VStack
                .onAppear { self.carregaLink() }
        } //ScrollView
            .navigationBarTitle(
                Text(post.titulo)
                    .font(.system(.title, design: .rounded)),displayMode: .automatic)
            .padding(.horizontal)
            .navigationBarItems(trailing:
                Button(action: {self.changeBookmark()}){
                    Image(systemName: bookmarkImage)
                        .imageScale(.large)
                        .foregroundColor(.primary)
                }
            )
        
    } //body
    
    func carregaLink(){
        if let link = post.link {
            //stored_link = post.link
            stored_link = Link.loadLink(link.id) // do cache
        }
    }
    
    func changeBookmark(){
        bookmarked.toggle()
        if bookmarked {
            bookmarkImage = "bookmark.fill"
        }
        else {
            bookmarkImage = "bookmark"
        }
    }
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0], membro: DAO().salas[0].membros[0])
    }
}
