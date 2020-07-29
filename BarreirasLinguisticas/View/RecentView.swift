//
//  RecentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RecentView: View {
    let post: Post
    var body: some View {
        ZStack {
            //Card
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 130)
                .padding()
            
            VStack {
                
                VStack(alignment: .leading) {
                    //Title of the post
                    HStack {
                        Spacer()
                        Text(post.titulo)
                            .font(.body)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                            .lineLimit(2)
                        Spacer()
                    }
                    
                    //Text of the post
                    Text(verbatim: post.descricao!)
                        .font(.body)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(5)
                }
                .padding(.horizontal, 32)
                .frame(height: 190.0)
            }
        }//ZStack
        .shadow(radius: 15)
    }//body
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        RecentView(post: DAO().posts[0])
    }
}
