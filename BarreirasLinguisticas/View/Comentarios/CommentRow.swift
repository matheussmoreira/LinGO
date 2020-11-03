//
//  CommentRow.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentRow: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var comentario: Comentario
    @State private var answer: String = ""
    
    var body: some View {
        ZStack {                    
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        comentario.publicador.usuario.foto_perfil
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
//                            .padding(.leading)
                        
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
                                    .lineLimit(1)
                                
                                Circle()
                                    .fill(comentario.publicador.usuario.cor_fluencia)
                                    .frame(width: 10.0, height: 10.0)
                                    .padding(.trailing)
                            }
                            Text(dao.getSala(id: membro.idSala)!.nome)
                                .frame(height: 6.0)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                        } //VStack
                    } //HStack
                    
                    HStack {
                        Text(comentario.conteudo)
                            .font(.body)
                            .padding(.all)
                            .lineLimit(10)
                            .frame(width: UIScreen.width*0.95)
                            .multilineTextAlignment(.leading)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                       // Spacer()
                    }
                }.padding(.all) //VStack
                
//                HStack {
//                    membro.usuario.foto_perfil
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 20.0, height: 20.0)
//                        .clipShape(Circle())
//                        .padding(.leading)
//
//                    TextField("Answer here", text: $answer)
//
//                } //HStack
//                    .padding(.horizontal)
            } //VStack
        }//ZStack
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(comentario: dao.salas[0].posts[1].comentarios[0])
            .environmentObject(dao.salas[0].membros[0])
    }
}
