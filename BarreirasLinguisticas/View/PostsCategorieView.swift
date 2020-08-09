//
//  PostsCategorieView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostsCategorieView: View {
    @ObservedObject var categoria: Categoria
    @ObservedObject var membro: Membro
    @ObservedObject var sala: Sala
    @State private var postSelectionado: Post?
    @State var subscribed = false
    @State var subscribedImage = "checkmark.circle"
    
    var posts: [Post] {
        return sala.getPostsByCategorie(categ: categoria.id)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(categoria.nome)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
                Button(action:{self.changeSubscription()}){
                    Image(systemName: subscribedImage)
                    .padding(.trailing)
                    .imageScale(.large)
                    .foregroundColor(.primary)
                }
            }
            
            SearchBarView(mensagem: "Search for posts in \(categoria.nome)")
            
            if posts.count == 0 {
                Spacer()
                Text("No posts in \(categoria.nome) :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(posts) { post in
                        NavigationLink(destination: PostView(post: post, membro: self.membro)) {
                            PostCardImageView(post: post)
                        }
                    }
                }
            } //else
        } //VStack
        
    } //body
    
    func changeSubscription(){
        subscribed.toggle()
        if subscribed {
            subscribedImage = "checkmark.circle.fill"
        }
        else {
            subscribedImage = "checkmark.circle"
        }
    }
}

struct PostsCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        PostsCategorieView(categoria: DAO().salas[0].categorias[0], membro: DAO().salas[0].membros[0], sala: DAO().salas[0])
    }
}
