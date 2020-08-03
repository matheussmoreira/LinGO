//
//  PostView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 01/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

/*
 titulo: String
 descricao: String?
 link: Link?
 publicador: Membro.Usuario.nome
 tags: [Tag]
 */

import SwiftUI
import LinkPresentation

struct PostView: View {
    @ObservedObject var post: Post
    @State var stored_link: Link?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                Text(post.titulo)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text(post.descricao!)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if stored_link != nil {
                    if stored_link?.metadata != nil {
                        LinkView(metadata: stored_link!.metadata!)
                    }
                    else {
                        Text("Metadata nil")
                            .foregroundColor(Color.gray)
                    }
                }
                else {
                    Text("Link nil")
                        .foregroundColor(Color.gray)
                }
                
            } //VStack
            .onAppear { self.pegaLink() }
        } //ScrollView
    } //body
    
    func pegaLink(){
        if let id = post.link?.id {
            stored_link = Link.loadLink(id)
        }
    } //pegaLink
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0])
    }
}
