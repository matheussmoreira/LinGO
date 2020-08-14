//
//  QuestionRow.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct QuestionRow: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var comentario: Comentario
    @State private var voted = false
    @State private var votedImage = "hand.raised"
    @State private var answer: String = ""
    
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
                            Text(membro.sala.nome)
                                .frame(height: 6.0)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                        } //VStack
                    } //HStack
                    
                    HStack {
                        Text(comentario.conteudo)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.width*0.75, height: 70.0)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal)

                        Spacer()
                        
                        Button(action: {self.changeVoted()}) {
                            Image(systemName: votedImage)
                                .resizable()
                                .frame(width: 30.0, height: 40.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .frame(width: 60.0, height: 80.0)
                                )
                            VStack {
                                ZStack{
                                    Image(systemName: "circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.red)
                                    Text("\(comentario.votos.count)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        } //Button
                            .padding(.leading)
                    } //HStack
                        .padding(.trailing)
                } //VStack
                    .padding(.horizontal)
            } //ZStack
            
            //MARK: - ANSWER HERE
            HStack {
                Image(membro.usuario.foto_perfil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20.0, height: 20.0)
                    .clipShape(Circle())
                    .padding(.leading)
                
                TextField("Answer here", text: $answer)
                
            } //HStack
                .padding(.horizontal)
        } //VStack
            .onAppear { self.loadVoto() }
    } //body
    
    func loadVoto(){
        if comentario.checkVotoExists(membro: membro) {
            voted = true
            votedImage = "hand.raised.fill"
        }
    }
    
    func changeVoted(){
        voted.toggle()
        if voted {
            votedImage = "hand.raised.fill"
            comentario.ganhaVoto(membro: membro)
        }
        else {
            votedImage = "hand.raised"
            comentario.perdeVoto(membro: membro)
        }
    }
}

struct QuestionRow_Previews: PreviewProvider {
    static var previews: some View {
        QuestionRow(comentario: DAO().salas[0].posts[1].comentarios[0])
            .environmentObject(DAO().salas[0].membros[0])
    }
}
