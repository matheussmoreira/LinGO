//
//  CommentsQuestionsToggle.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 07/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI


struct CommentsQuestionsToggle: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var post: Post
    @State var questions_selected = true
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top)
            
            Toggle(questions_selected: $questions_selected)
            
            if questions_selected {
                CallQuestions(post: post)
                    .environmentObject(membro)
            }
            else {
                CallComments(post: post)
                    .environmentObject(membro)
            }
        } //VStack
        
    } //body
    
}

//struct CommentsQuestionsToggle_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsQuestionsToggle(post: DAO().salas[0].posts[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}

struct CallQuestions: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var post: Post
    @State private var questions: [Comentario] = []
    @State private var textFieldMinHeight: CGFloat = 50
    @State private var newComment: String = ""
    @State private var askApagaPergunta = false
    @State private var askReport = false
    @State private var reported = false
    @State private var showAlertBlocked = false
    
    var body: some View {
        VStack{
            HStack {
                Text("Write a question")
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
                .frame(width: UIScreen.width - 20, height: 150)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Divider()
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            if questions.isEmpty {
                EmptyView(message: "No questions for this post 😕")
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(questions.reversed().sorted(by: { $0.votos.count > $1.votos.count })) { comment in
                        if comment.is_question {
                            VStack {
                                QuestionRow(comentario: comment)
                                    .environmentObject(self.membro)
                                HStack {
                                    if (comment.publicador.id == membro.id) || (!comment.denuncias.isEmpty && membro.isAdmin) {
                                        Button(action: {
                                            askApagaPergunta.toggle()
                                        }){
                                            Image(systemName: "trash.circle")
                                                .padding(.leading)
                                                .imageScale(.large)
                                            
                                        }.alert(isPresented: $askApagaPergunta) {
                                            Alert(
                                                title: Text("Delete this question?"),
                                                primaryButton: .default(Text("Delete")){
                                                    apagaPergunta(id: comment.id)
                                                },
                                                secondaryButton: .cancel())
                                        }
                                        .padding(.leading)
                                    }
                                    
                                    if !membro.isBlocked /*&& membro.id != comment.publicador.id */{
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
                                    Spacer()
                                }.padding(.leading)
                                Divider()
                            }.onAppear{
                                loadReport(of: comment)
                            }
                        }
                    }
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
            } //else
        }//VStack
            .onAppear {
                self.loadQuestions()
            }
    } //body
    
    func report(_ question: Comentario){
        question.updateReportStatus(membro: membro)
        reported = question.denuncias.contains(membro.id)
    }
    
    func loadReport(of question: Comentario){
        reported = question.denuncias.contains(membro.id)
    }
    
    func apagaPergunta(id: String){
        post.apagaPergunta(id: id)
        loadQuestions()
    }
    
    func loadQuestions() {
        DispatchQueue.main.async {
            questions = post.perguntas
        }
    }
    
    func comenta() {
        if newComment != "" {
            post.novoComentario(publicador: membro, conteudo: newComment, is_question: true)
                loadQuestions()
                newComment = ""
        }
    }
}

struct CallComments: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var post: Post
    @State private var comments: [Comentario] = []
    @State private var newComment: String = ""
    @State private var textFieldMinHeight: CGFloat = 50
    @State private var askApagaComentario = false
    @State private var askReport = false
    @State private var reported = false
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
                .frame(width: UIScreen.width - 20, height: 150)
                .cornerRadius(10)
                .shadow(radius: 5)
                
            Divider()
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }

            if comments.isEmpty {
                EmptyView(message: "No comments for this post 😕")
            }
            else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(comments.reversed()) { comment in
                        if !comment.is_question {
                            VStack {
                                CommentRow(comentario: comment)
                                    .environmentObject(self.membro)
                                
                                HStack {
                                    if (comment.publicador.id == membro.id) || (!comment.denuncias.isEmpty && membro.isAdmin) {
                                        Button(action: {
                                            askApagaComentario.toggle()
                                        }){
                                            Image(systemName: "trash.circle")
                                                .padding(.leading)
                                                .imageScale(.large)
                                        }.alert(isPresented: $askApagaComentario) {
                                            Alert(
                                                title: Text("Delete this comment?"),
                                                primaryButton: .default(Text("Delete")){
                                                    apagaComentario(id: comment.id)
                                                },
                                                secondaryButton: .cancel())
                                        }
                                        .padding(.leading)
                                    }
                                    
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
                                    Spacer()
                                }.padding(.leading)
                                
                                Divider()
                            }.onAppear{
                                loadReport(of: comment)
                            }
                        }
                    }
                }.onTapGesture {
                    self.hideKeyboard()
                }
            } //else
        } //VStack
        .onAppear {self.loadComments()}
    } //body
    
    func report(_ comment: Comentario){
        comment.updateReportStatus(membro: membro)
        reported = comment.denuncias.contains(membro.id)
    }
    
    func loadReport(of comentario: Comentario){
        reported = comentario.denuncias.contains(membro.id)
    }
    
    func apagaComentario(id: String){
        post.apagaComentario(id: id)
        loadComments()
    }
    
    func loadComments() {
        DispatchQueue.main.async {
            comments = post.comentarios
        }
    }
    
    func comenta() {
        if newComment != "" {
            post.novoComentario(publicador: membro, conteudo: newComment, is_question: false)
                loadComments()
                newComment = ""
        }
    }
}

struct EmptyView: View {
    var message: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(.gray)
            Spacer()
        }
    } //body
}

struct Toggle: View {
    @Binding var questions_selected: Bool
    @State private var comments_selected = false
    @State private var questions_color = Color.primary
    @State private var comments_color = Color.blue
    
    var body: some View {
        VStack {
            //TRACINHO DO SHEET
//            Rectangle()
//                .frame(width: 60, height: 6)
//                .cornerRadius(3.0)
//                .opacity(0.1)
//                .padding(.top,10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: UIScreen.width-20)
                
                HStack {
                    HStack {
                        Button(action: {
                            self.switchValue(state: self.questions_selected)
                        }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(questions_color)
                            Text("Questions")
                                .font(.subheadline)
                                .foregroundColor(questions_color)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Divider()
                    
                    HStack {
                        Button(action: {
                            self.switchValue(state: self.comments_selected)
                        }) {
                            Image(systemName: "bubble.left")
                                .foregroundColor(comments_color)
                            Text("Comments")
                                .font(.subheadline)
                                .foregroundColor(comments_color)
                        }
                    }
                    .padding(.horizontal, 32)
                } //HStack
            } //ZStack
                .frame(height: 40.0)
                .padding()
        }
    } //body
    
    func switchValue(state isOn: Bool) {
        if !isOn {
            questions_selected.toggle()
            comments_selected.toggle()
            if questions_selected {
                questions_color = Color.primary
                comments_color = LingoColors.lingoBlue
            }
            else {
                questions_color = LingoColors.lingoBlue
                comments_color = Color.primary
            }
        }
    } //switchValue
}
