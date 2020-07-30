//
//  RecentsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RecentsView: View {
    let post: Post
    
    var body: some View {
        ZStack {
            //CARD
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 130)
                .padding()
            
            VStack {
                VStack(alignment: .leading) {
                    //TITULO DO POST
                    HStack {
                        Spacer()
                        Text(post.titulo)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                            .lineLimit(2)
                        Spacer()
                    }
                    
                    //DESCRICAO DO POST
                    Text(verbatim: post.descricao!)
                        .font(.body)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(5)
                }
                .padding(.horizontal, 32)
                .frame(height: 190.0)
            } //VStack
        } //ZStack
        .shadow(radius: 15)
    } //body
}

struct RecentsView_Preview: PreviewProvider {
    static var previews: some View {
        RecentsView(post: DAO().salas[0].posts[0])
    }
}
