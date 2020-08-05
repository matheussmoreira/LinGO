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
        
        ZStack {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {

            VStack(alignment: .leading){

//                Text(post.titulo)
//                    .fontWeight(.bold)
//                    .lineLimit(2)
//                    .font(.system(.title, design: .rounded))
                
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
                    Text("Tags")
                    .foregroundColor(Color.blue)
                    .lineLimit(1)
                
                Text(post.descricao!)
                    .padding(.bottom)
                
                if (stored_link != nil && stored_link?.metadata != nil) {
                    LinkView(metadata: stored_link!.metadata!)
//                        .padding(.all)
                }
            } //VStack
            .onAppear { self.carregaLink() }
        } //ScrollView
                .navigationBarTitle(Text(post.titulo), displayMode: .automatic)
                .padding(.horizontal)
        }//body
}
    }
    
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
