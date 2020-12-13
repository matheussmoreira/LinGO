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
    @ObservedObject var original: Comentario
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
                
                if original.respostas.isEmpty {
                    if !original.allRespostasLoaded {
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
                            ForEach(original.respostas.reversed()) { resposta in
                                AnswerRow(resposta: resposta, original: original)
                                    .environmentObject(membro)
                                    .environmentObject(sala)
                            }
                            if !original.allRespostasLoaded  {
                                ProgressView("")
                            }
                        }.frame(width: UIScreen.width)
                    }
//                    .onAppear{
//                        print("COMECO RESPOSTAS")
//                        for resp in pergunta.respostas{
//                            print("\t\(resp.conteudo)")
//                        }
//                        print("FIM RESPOSTAS")
//                    }
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
                id_original: original.id,
                original: original,
                publicador: membro,
                conteudo: newAnswer
            )
            original.ganhaResposta(resposta, sala: sala)
            newAnswer = ""
        }
    }
}

//struct AnswersView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswersList()
//    }
//}
