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
    var stored_link: Link? {
        return LinkManager().loadLink(post.link?.id ?? 0)
    }
    //var link_manager = LinkManager(id_link: self.p)

    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
                        LinkView(metadata: stored_link?.metadata)
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
        } //ScrollView
    } //body
    
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0])
    }
}
