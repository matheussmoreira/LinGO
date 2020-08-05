//
//  CommentRow.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentRow: View {
    var body: some View {
        
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 80)
                .shadow(radius: 8)
                .padding()
            
            VStack {
                HStack {
                    Image("foto_leo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30.0, height: 30.0)
                        .clipShape(Circle())
                        .padding(.leading)
                    
                    Text("Leonardo da Vinci")
                        .fontWeight(.bold)
                    
                    Spacer()
                    HStack {
                        Text("Fluencia")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Circle()
//                          .fill(comentario.publicador.usuario.cor_fluencia)
                            .frame(width: 10.0, height: 10.0)
                            .padding(.trailing)
                    }
                    
                } //HStack
                HStack {
                    Text("usahusha")
                        .padding(.horizontal)
                        
                    Spacer()
                }
            } //VStack
            .padding(.horizontal)
        } //ZStack
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow()
    }
}
