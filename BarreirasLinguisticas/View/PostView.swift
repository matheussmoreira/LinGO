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
    @State var stored_link: Link?
    @State var showComments = false
    
    var body: some View {
        
        ZStack {
            NavigationView {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading){
                        
//                        Text(post.titulo)
//                            .fontWeight(.bold)
//                            .lineLimit(2)
//                            .font(.system(.title, design: .rounded))
                        
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
                        HStack{
                            ForEach(post.tags) { tag in
                                Text("#\(tag.nome)")
                                    .foregroundColor(Color.blue)
                            }
                            Spacer()
                        }
                        Text(post.descricao!)
                            .padding(.bottom)
                        
                        if (stored_link != nil && stored_link?.metadata != nil) {
                            LinkView(metadata: stored_link!.metadata!)
                        }
                        Button(action: {self.showComments.toggle()}) {
                            Text("Comentários")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                        }
                        .sheet(isPresented: $showComments) {
                            
                            if (self.post.comentarios.count == 0) {
                                Text("No comments for this post :(")
                                    .foregroundColor(.gray)
                            }
                            else {
                                VStack {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(self.post.comentarios){ comentario in
                                            CommentView(comentario: comentario)
                                        }
                                    }
                                }
                            } //else
                        } //sheet
                    } //VStack
                        .onAppear { self.carregaLink() }
                } //ScrollView
                    .navigationBarTitle(
                        Text(post.titulo)
                    .font(.system(.title, design: .rounded)),displayMode: .automatic)
                    .padding(.horizontal)
            }//body
        }
    }
    
    func carregaLink(){
        if let link = post.link {
            stored_link = post.link
            //stored_link = Link.loadLink(link.id) // do cache
        }
    }
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0])
    }
}
