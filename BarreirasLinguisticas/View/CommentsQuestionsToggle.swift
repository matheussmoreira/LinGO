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
    @State var questions: [Comentario] = []
    @State var not_questions: [Comentario] = []
    @State var questions_selected = true
    
    var body: some View {
        VStack {
            Toggle(questions_selected: $questions_selected)
            
            if questions_selected {
                CallQuestions(post: post, questions: questions).environmentObject(membro)
            }
            else {
                CallComments(comments: not_questions).environmentObject(membro)
            }
        } //VStack
            .onAppear { self.getComments() }
        
    } //body
    
    func getComments(){
        questions = post.comentarios.filter{$0.is_question == true}
        not_questions = post.comentarios.filter{$0.is_question == false}
    }
}

struct CommentsQuestionsToggle_Previews: PreviewProvider {
    static var previews: some View {
        CommentsQuestionsToggle(post: DAO().salas[0].posts[0])
            .environmentObject(DAO().salas[0].membros[0])
    }
}

struct CallQuestions: View {
    @ObservedObject var post: Post
    @EnvironmentObject var membro: Membro
    var questions: [Comentario]
    @State var textHeight: CGFloat = 20
    @State var newComment: String = ""
    
    var body: some View {
        VStack{
            if questions.count == 0 {
                EmptyView(message: "No questions for this post :(")
            }
            else {
                HStack {
                    Text("Write a comment")
                        .font(.headline)
                        .padding(.leading, 15)
                    Spacer()
                    ZStack {
                        Capsule()
                            .frame(width: 50.0, height: 40.0)
                            .foregroundColor(LingoColors.lingoBlue)
                        Button("Go!") {
                            self.comenta()
                        }
                        .foregroundColor(.white)
                    }.padding(.trailing, 15)
                }
                
                MultilineTextField(placeholder: "Call me baby", text: self.$newComment, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                    .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                    .frame(width: UIScreen.width - 20)
                    .shadow(radius: 5)
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(questions) { comment in
                        if comment.is_question {
                            QuestionRow(comentario: comment).environmentObject(self.membro)
                            Divider()
                        }
                    }
                }
            } //else
        }
    } //body
    
    func comenta() {
        newComment = ""
    }
}

struct CallComments: View {
    @EnvironmentObject var membro: Membro
    var comments: [Comentario]
    
    var body: some View {
        VStack {
            if comments.count == 0 {
                EmptyView(message: "No comments for this post :(")
            }
            else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(comments) { comment in
                        if !comment.is_question {
                            CommentRow(comentario: comment).environmentObject(self.membro)
                            Divider()
                        }
                    }
                }
            } //else
        }
    } //body
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
    @State var comments_selected = false
    @State var questions_color = Color.black
    @State var comments_color = Color.blue
    
    var body: some View {
        VStack {
            //TRACINHO DO SHEET
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top,10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                HStack {
                    HStack {
                        Button(action: {
                            self.switchValue(state: self.questions_selected)
                        }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(questions_color)
                            Text("Questions")
                                .font(.headline)
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
                                .font(.headline)
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
                questions_color = Color.black
                comments_color = Color.blue
            }
            else {
                questions_color = Color.blue
                comments_color = Color.black
            }
        }
    } //switchValue
}
