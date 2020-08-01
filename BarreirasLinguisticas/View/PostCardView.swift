//
//  FYCardView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostCardView: View {
    @ObservedObject var post: Post
    
    var body: some View {
        ZStack {
            //CARD
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 260)
                .padding()
            
            VStack {
                HStack {
                    //NOME DA CATEGORIA
                    Text(post.categorias[0].nome) // vai ser so o primeiro mesmo ???
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    //SHARED BY \(SOMEONE)
                    Text("Shared by \(post.publicador.usuario.nome)")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    //ENGLISH FLUENCY COLOR
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundColor(post.publicador.usuario.cor_fluencia)
                    
                } .padding(.horizontal, 32)
                
                VStack(alignment: .leading) {
                    //TITULO DO POST
                    Text(post.titulo)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 5)
                        .font(.system(.title, design: .rounded))
                        .lineLimit(2)
                    
                    HStack {
                        //DESCRICAO DO POST
                        Text(verbatim: post.descricao!)
                            .font(.body)
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .frame(height: 190.0)
                
                //TAGS DO POST
                HStack {
                    ForEach(post.tags) { tag in
                        Text(tag.nome)
                        .foregroundColor(Color.blue)
                        .lineLimit(1)
                    }
                    Spacer()
                } .padding(.horizontal, 32)
                
            } // VStack
        } //ZStack
        .shadow(radius: 15)
    } //body
}

struct FYCardView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardView(post: DAO().salas[0].posts[0])
    }
}
