//
//  CommentsList.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentsList: View {
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @ObservedObject var post: Post
    @State private var newComment: String = ""
    @State private var showAlertBlocked = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Write a comment")
                    .font(.headline)
                    .padding(.leading, 20)
                
                Spacer()
                ZStack {
                    Capsule()
                        .frame(width: 50.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    Button("Go!") {
                        if !membro.isBlocked {
                            self.comenta()
                            self.hideKeyboard()
                        } else {
                            self.showAlertBlocked.toggle()
                            newComment = ""
                        }
                    }
                    .foregroundColor(.white)
                    .alert(isPresented: $showAlertBlocked, content: {
                        Alert(
                            title: Text("You cannot comment because you are blocked!"),
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
            
            TextEditor(text: self.$newComment)
                //                .frame(width: UIScreen.width - 20, height: 150)
                .frame(height: 150)
                .padding(.horizontal)
                .cornerRadius(20)
                .shadow(radius: 5)
            
            Divider()
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            if post.comentarios.isEmpty {
                if !post.allComentariosLoaded {
                    VStack {
                        Spacer()
                        ProgressView("")
                        Spacer()
                    }
                    // Dois spacers com Vstack pois sem isso ToggleBar nao fica no topo
                } else {
                    // Carregou tudo e de fato nao ha comentarios
                    VStack {
                        Spacer()
                        Text("No comments for this post 😕")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(post.comentarios.reversed()) { comment in
                            CommentDetails(comment: comment, post: post)
                                .environmentObject(sala)
                        }
                        if !post.allComentariosLoaded {
                            ProgressView("")
                        }
                    }
                }.onTapGesture {
                    self.hideKeyboard()
                }
            } //else
        } //VStack
        .frame(width: UIScreen.width)
    } //body
    
    func comenta() {
        if newComment != "" {
            post.novoComentario(
                sala: sala,
                publicador: membro,
                conteudo: newComment,
                is_question: false
            )
            newComment = ""
        }
    }
}

struct CommentDetails: View {
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @ObservedObject var comment: Comentario
    @ObservedObject var post: Post
    @State private var askReport = false
    @State private var askApagaComentario = false
    @State private var reported = false
    
    var body: some View {
        VStack {
            CommentRow(comentario: comment)
                .environmentObject(self.membro)
            
            HStack {
                // Botaozinho de denunciar
                if !membro.isBlocked /*&& membro.id != comment.publicador.id*/ {
                    Button(action: {
                        askReport.toggle()
                    }){
                        Image(systemName: reported ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                            .imageScale(.large)
                            .padding(.leading)
                        
                    }.alert(isPresented: $askReport) {
                        Alert(
                            title: Text(reported ? "Dismiss report?" : "If you report then the admins of the room will be able to delete this question"),
                            primaryButton: .default(Text(reported ? "Yes" : "Report")){
                                report(comment)
                            },
                            secondaryButton: .cancel())
                    }
                }
                
                // Botaozinho de apagar
                if (comment.publicador.id == membro.id) || (!comment.denuncias.isEmpty && membro.isAdmin) {
                    Button(action: {
                        askApagaComentario.toggle()
                    }){
                        Image(systemName: "trash.circle")
                            //                                                .padding(.leading)
                            .imageScale(.large)
                    }.alert(isPresented: $askApagaComentario) {
                        Alert(
                            title: Text("Delete this comment?"),
                            primaryButton: .default(Text("Delete")){
                                apagaComentario(id: comment.id)
                            },
                            secondaryButton: .cancel())
                    }
                    //                                        .padding(.leading)
                }
                
                
                Spacer()
            }.padding(.leading)
            
            Divider()
        }.onAppear{
            loadReport(of: comment)
        }
    }
    
    func report(_ comment: Comentario){
        comment.updateReportStatus(membro: membro)
        reported = comment.denuncias.contains(membro.id)
        print("Updated report status of: \(comment.conteudo)")
    }
    
    func loadReport(of comentario: Comentario){
        reported = comentario.denuncias.contains(membro.id)
    }
    
    func apagaComentario(id: String){
        post.apagaComentario(sala: sala, id: id)
    }
}
