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
            Toggle(questions_selected: $questions_selected)
            
            if questions_selected {
                CallQuestions(post: post).environmentObject(membro)
            }
            else {
                CallComments(post: post).environmentObject(membro)
            }
        } //VStack
        
    } //body
    
}

struct CommentsQuestionsToggle_Previews: PreviewProvider {
    static var previews: some View {
        CommentsQuestionsToggle(post: DAO().salas[0].posts[0])
            .environmentObject(DAO().salas[0].membros[0])
    }
}

struct CallQuestions: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var post: Post
    @State private var questions: [Comentario] = []
    @State private var textFieldMinHeight: CGFloat = 50
    @State private var newComment: String = ""
    
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
                        self.comenta()
                        self.hideKeyboard()
                    }
                    .foregroundColor(.primary)
                    .colorInvert()
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
            
//            MultilineTextField(placeholder: "", text: self.$newComment, minHeight: self.textFieldMinHeight, calculatedHeight: self.$textFieldMinHeight)
//                .frame(minHeight: self.textFieldMinHeight, maxHeight: self.textFieldMinHeight)
//                .frame(width: UIScreen.width - 20)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//
            Divider()
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            if questions.isEmpty {
                EmptyView(message: "No questions for this post :(")
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(questions.reversed().sorted(by: { $0.votos.count > $1.votos.count })) { comment in
                        if comment.is_question {
                            QuestionRow(comentario: comment)
                                .environmentObject(self.membro)
                            Divider()
                        }
                    }
                }.onTapGesture {
                    self.hideKeyboard()
                }
            } //else
        }//VStack
            .onAppear {self.loadQuestions()}
    } //body
    
    func loadQuestions() {
        questions = post.perguntas
    }
    
    func comenta() {
        if newComment != "" {
            post.novoComentario(id: UUID().hashValue, publicador: membro, conteudo: newComment, is_question: true)
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
                        self.comenta()
                        self.hideKeyboard()
                    }
                    .foregroundColor(.primary)
                    .colorInvert()
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
            
//            MultilineTextField(placeholder: "", text: self.$newComment, minHeight: self.textFieldMinHeight, calculatedHeight: self.$textFieldMinHeight)
//                .frame(minHeight: self.textFieldMinHeight, maxHeight: self.textFieldMinHeight)
//                .frame(width: UIScreen.width - 20)
//                .cornerRadius(10)
//                .shadow(radius: 5)
                
            Divider()
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }

            if comments.isEmpty {
                EmptyView(message: "No comments for this post :(")
            }
            else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(comments.reversed()) { comment in
                        if !comment.is_question {
                            CommentRow(comentario: comment)
                                .environmentObject(self.membro)
                            Divider()
                        }
                    }
                }.onTapGesture {
                    self.hideKeyboard()
                }
                //.frame(width: UIScreen.width*0.95)
            } //else
        } //VStack
        .onAppear {self.loadComments()}
    } //body
    
    func loadComments() {
        comments = post.comentarios
    }
    
    func comenta() {
        if newComment != "" {
            post.novoComentario(id: UUID().hashValue, publicador: membro, conteudo: newComment, is_question: false)
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
