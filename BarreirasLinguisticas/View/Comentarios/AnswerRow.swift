//
//  AnswerRow.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 11/12/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct AnswerRow: View {
    @ObservedObject var resposta: Resposta
    @EnvironmentObject var membro: Membro
    @State private var askApagaResposta = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        Image(uiImage: resposta.publicador.usuario.foto_perfil?.asUIImage() ?? UIImage(named: "perfil")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
//                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(resposta.publicador.usuario.nome)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .frame(height: 20.0)
                                
                                Spacer()
                                
                                Text(resposta.publicador.usuario.fluencia_ingles.rawValue)
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                    .lineLimit(1)
                                
                                Circle()
                                    .fill(resposta.publicador.usuario.cor_fluencia)
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
                        Text(resposta.conteudo)
                            .font(.body)
                            .padding(.all)
                            .lineLimit(10)
                            .frame(width: UIScreen.width*0.95)
                            .multilineTextAlignment(.leading)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                    }
                }.padding(.all) //VStack
                
                // Botaozinho de Apagar
                if (resposta.publicador.id == membro.id) || (membro.isAdmin) {
                    HStack {
                        Button(action: {
                            askApagaResposta.toggle()
                        }){
                            Image(systemName: "trash.circle")
                                .imageScale(.large)
                            
                        }.alert(isPresented: $askApagaResposta) {
                            Alert(
                                title: Text("Delete this answer?"),
                                primaryButton: .default(Text("Delete")){
                                },
                                secondaryButton: .cancel())
                        }
                        Spacer()
                    }.padding(.leading)
                    
                    Divider()
                }
            } //VStack
        }//ZStack
    }
}

//struct AnswerRow_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswerRow()
//    }
//}
