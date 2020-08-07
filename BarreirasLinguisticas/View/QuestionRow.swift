//
//  QuestionRow.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct QuestionRow: View {
    @ObservedObject var comentario: Comentario
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        Image(comentario.publicador.usuario.foto_perfil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comentario.publicador.usuario.nome)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .frame(height: 20.0)
                                
                                Spacer()
                                Text(comentario.publicador.usuario.fluencia_ingles.rawValue)
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                Circle()
                                    .fill(comentario.publicador.usuario.cor_fluencia)
                                    .frame(width: 10.0, height: 10.0)
                                    .padding(.trailing)
                            }
                            Text("Apple Developer Academy | PUC-Rio | Brazil")
                                .frame(height: 6.0)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                        } //VStack
                    } //HStack
                    
                    HStack {
                        Text(comentario.conteudo)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .frame(height: 100.0)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Button(action: vote) {
                            Image(systemName: "hand.raised")
                                .resizable()
                                .frame(width: 30.0, height: 40.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .frame(width: 60.0, height: 80.0)
                            )
                        } //Button
                            .padding(.leading)
                    } //HStack
                        .padding(.trailing)
                    
                } //VStack
                    .padding(.horizontal)
            }
            HStack {
                Image("foto_evelyn")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20.0, height: 20.0)
                    .clipShape(Circle())
                    .padding(.leading)
                
                TextField("Answer here", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .font(.footnote)
                
            } //HStack
            .padding(.horizontal)
        }//VStack
    } //body
} //struct

func vote() {
    
}


struct QuestionRow_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRow(comentario: DAO().salas[0].posts[1].comentarios[0])
    }
}
