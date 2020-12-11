//
//  AnswersList.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 11/12/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct AnswersList: View {
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @ObservedObject var pergunta: Comentario
    @State private var newAnswer: String = ""
    @State private var showAlertBlocked = false
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top)
            
            HStack {
                Text("Answers")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
            }
            
            VStack{
                HStack {
                    Text("Write an answer")
                        .font(.headline)
                        .padding(.leading, 20)
                    
                    Spacer()
                    ZStack {
                        Capsule()
                            .frame(width: 50.0, height: 40.0)
                            .foregroundColor(LingoColors.lingoBlue)
                        Button("Go!") {
                            if !membro.isBlocked {
                                self.responde()
                                self.hideKeyboard()
                            } else {
                                self.showAlertBlocked.toggle()
                                newAnswer = ""
                            }
                        }
                        .foregroundColor(.white)
                        .alert(isPresented: $showAlertBlocked, content: {
                            Alert(
                                title: Text("You cannot answer because you are blocked!"),
                                dismissButton: .default(Text("Ok"))
                            )
                        })
                    }
                    .padding(.trailing, 20)
                }
                .frame(width: UIScreen.width)
                .onTapGesture {
                    self.hideKeyboard()
                }
                
                TextEditor(text: self.$newAnswer)
                    .frame(height: 150)
                    .padding(.horizontal)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                
                Divider()
                    .padding(.vertical)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                if pergunta.respostas.isEmpty {
                    if !pergunta.allRespostasLoaded {
                        /*  Dois spacers com Vstack pois
                         sem isso ToggleBar nao fica no topo
                         */
                        VStack {
                            Spacer()
                            ProgressView("")
                            Spacer()
                        }
                    } else {
                        // Carregou tudo e de fato nao ha perguntas
                        VStack {
                            Spacer()
                            Text("No answers for this question 😕")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(pergunta.respostas.reversed()) { resposta in
                                AnswerRow(resposta: resposta)
                                    .environmentObject(membro)
                            }
                            if !pergunta.allRespostasLoaded  {
                                ProgressView("")
                            }
                        }.frame(width: UIScreen.width)
                    }
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                } //else
            }//VStack
            .frame(width: UIScreen.width)
            
        }.navigationBarTitle(Text("Answers"))
        
    }
    
    func responde(){
        if newAnswer != "" {
            let resposta = Resposta(
                id_original: pergunta.id,
                publicador: membro,
                conteudo: newAnswer
            )
            pergunta.ganhaResposta(resposta)
            newAnswer = ""
        }
    }
}

//struct AnswersView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswersList()
//    }
//}

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
