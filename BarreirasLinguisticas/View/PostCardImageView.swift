//
//  PostCardImageView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostCardImageView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var post: Post
    @State private var link_image: UIImage?
    @State private var line_limit_title = 2
    @State private var font_size_title = Font.TextStyle.title
    @State private var line_limit_desc = 4
    var width: CGFloat
    
    var body: some View {
        ZStack {
            //CARD
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(UIColor.white))
                //.fill(Color("cardColor"))
                .frame(height: 260)
                .shadow(radius: 8)
                .padding()

            VStack {
                HStack {
                    //NOME DAS CATEGORIAS
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(post.categorias) { categ in
                                Text(categ.nome)
                                    .fontWeight(.semibold)
                                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .frame(width: 120.0)
                    
                    Spacer()
                    
                    //SHARED BY
                    Text("Shared by \(post.publicador.usuario.nome)")
                        //.foregroundColor(Color.gray)
                        .foregroundColor(self.colorScheme == .dark ? Color.white : Color.gray)
                        .lineLimit(1)
                    
                    //ENGLISH FLUENCY COLOR
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundColor(post.publicador.usuario.cor_fluencia)
                    
                } .padding(.horizontal, 32)
                
                //IMAGEM DO LINK
                if link_image != nil {
                    Image(uiImage: link_image!)
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.width*width, height: 100)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    //TITULO DO POST
                    Text(post.titulo)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 5)
                        .font(.system(font_size_title, design: .rounded))
                        .lineLimit(line_limit_title)
                    
                    HStack {
                        //DESCRICAO DO POST
                        Text(verbatim: post.descricao!)
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color(UIColor.systemGray))

                            .multilineTextAlignment(.leading)
                            .lineLimit(line_limit_desc)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                //TAGS DO POST
                HStack {
                    ForEach(0..<post.tags.count) { idx in
                        Text(self.post.tags[idx])
                            .foregroundColor(self.colorScheme == .dark ? Color.white : LingoColors.lingoBlue)
                            .lineLimit(1)
                    }
                    Spacer()
                } .padding(.horizontal, 32)
                
            } // VStack
            .frame(height: 244.0)
            .onAppear {self.getLinkImage(from: self.post.link)}
                
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
        PostCardImageView(post: DAO().salas[0].posts[0], width: 0.80)
    }
}
