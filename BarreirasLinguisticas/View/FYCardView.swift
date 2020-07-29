//
//  FYCardView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct FYCardView: View {
    let post: Post
    
    var body: some View {
        ZStack {
            //Card
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 260)
                .padding()
            
            VStack {
                HStack {
                    //Name of the Category
                    Text(post.categorias[0].nome)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    //Shared by \(someone)
                    Text("Shared by \(post.publicador.nome)")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    //English Level
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundColor(post.publicador.cor_fluencia)
                    
                } .padding(.horizontal, 32)
                
                VStack(alignment: .leading) {
                    //Title of the post
                    Text(post.titulo)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 5)
                        .font(.system(.title, design: .rounded))
                        .lineLimit(2)
                    
                    HStack {
                        //Text of the post
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
                
                //Related Tags
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
        FYCardView(post: DAO().posts[0])
    }
}
