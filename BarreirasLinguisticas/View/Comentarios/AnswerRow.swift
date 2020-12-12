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
    @ObservedObject var original: Comentario
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State private var askApagaResposta = false
    @State private var askReport = false
    @State private var reported = false
    
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
                
                HStack {
                    // Botaozinho de Denunciar
                    if !membro.isBlocked /*&& membro.id != comment.publicador.id */{
                        Button(action: {
                            askReport.toggle()
                        }){
                            Image(systemName: reported ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                                .imageScale(.large)
                                .padding(.leading)
                            
                        }.alert(isPresented: $askReport) {
                            Alert(
                                title: Text(reported ? "Dismiss report?" : "If you report then the admins of the room will be able to delete this answer"),
                                primaryButton: .default(Text(reported ? "Yes" : "Report")){
                                    report(resposta)
                                },
                                secondaryButton: .cancel())
                        }
                    }
                    
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
                                        original.perdeResposta(resposta, sala: sala)
                                    },
                                    secondaryButton: .cancel())
                            }
                            Spacer()
                        }
                    }
                }
                Divider()
            } //VStack
        }//ZStack
        .onAppear{
            loadReport(of: resposta)
        }
    }
    
    func report(_ resposta: Resposta){
        resposta.updateReportStatus(from: membro)
        reported = resposta.denuncias.contains(membro.id)
    }
    
    func loadReport(of resposta: Resposta){
        reported = resposta.denuncias.contains(membro.id)
    }
}

//struct AnswerRow_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswerRow()
//    }
//}
