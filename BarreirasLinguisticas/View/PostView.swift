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
                
                if (stored_link != nil && stored_link?.metadata != nil) {
                    LinkView(metadata: stored_link!.metadata!)
                        .padding(.all)
                }
            } //VStack
            .onAppear { self.carregaLink() }
        } //ScrollView
    } //body
    
    func carregaLink(){
        if let _ = post.link {
            stored_link = post.link
            //stored_link = Link.loadLink(id) // do cache
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0])
    }
}
