//
//  PostCardImageView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostCardImageView: View {
    @ObservedObject var post: Post
    @State var link_image: UIImage?
    @State var line_limit_title = 2
    @State var font_size_title = Font.TextStyle.title
    @State var line_limit_desc = 4
    
    var body: some View {
        ZStack {
            //CARD
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 260)
                .padding()
                .shadow(radius: 8)
                .overlay(
                    VStack {
                        HStack {
                            //NOME DA CATEGORIA
                            Text(post.categorias[0].nome) // qual categoria das várias (???)
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
                        
                        if link_image != nil {
                            Image(uiImage: link_image!)
                                .resizable()
                                .frame(width: UIScreen.width*0.85, height: 100)
                                .cornerRadius(10)
                        }
                        
                        VStack {
                            //TITULO DO POST
                            Text(post.titulo)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 5)
                                .font(.system(font_size_title, design: .rounded))
                                .lineLimit(line_limit_title)
                            
                            HStack {
                                //DESCRICAO DO POST
                                Text(verbatim: post.descricao!)
                                    .font(.body)
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(line_limit_desc)
                                
                                Spacer()
                            }
                            //Spacer()
                        }
                        .padding(.horizontal, 32)
                        //.frame(height: 190.0)
                        
                        //TAGS DO POST
                        HStack {
                            ForEach(post.tags) { tag in
                                Text("#\(tag.nome)")
                                    .foregroundColor(Color.blue)
                                    .lineLimit(1)
                            }
                            Spacer()
                        } .padding(.horizontal, 32)
                        
                    } // VStack
                    .onAppear {self.getLinkImage(from: self.post.link)}
            ) //overlay
        } //ZStack
    }
    
    func getLinkImage(from link: Link?) {
        if let image = post.link?.image_provider {
            self.link_image = image
            self.line_limit_title = 1
            self.line_limit_desc = 2
            self.font_size_title = Font.TextStyle.body
        }
    } //addLinkImage
}

struct PostCardImageView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardImageView(post: DAO().salas[0].posts[0])
    }
}
