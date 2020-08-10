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
    var comentarios: [Comentario]
    @State var questions: [Comentario] = []
    @State var not_questions: [Comentario] = []
    
    @State var questions_on = true
    
    var body: some View {
        VStack {
            Toggle(questions_on: $questions_on)
            
            if questions_on {
                if countCommentQuestions(isQuestion: true) == 0 {
                    EmptyView(message: "No questions for this post :(")
                }
                else {
                    CallQuestions(comments: questions).environmentObject(membro)
                }
            }
            else {
                if countCommentQuestions(isQuestion: false) == 0 {
                    EmptyView(message: "No comments for this post :(")
                }
                else {
                    CallComments(comments: not_questions).environmentObject(membro)
                }
            }
        } //VStack
            .onAppear { self.getQuestions() }
        
    } //body
    
    func getQuestions(){
        questions = comentarios.filter{$0.is_question == true}
        not_questions = comentarios.filter{$0.is_question == false}
    }
    
    func countCommentQuestions(isQuestion: Bool) -> Int {
        let comments = comentarios.filter{$0.is_question == isQuestion}
        return comments.count
    }
}

struct CommentsQuestionsToggle_Previews: PreviewProvider {
    static var previews: some View {
        CommentsQuestionsToggle(comentarios: DAO().salas[0].posts[0].comentarios)
            .environmentObject(DAO().salas[0].membros[0])
    }
}

struct CallComments: View {
    @EnvironmentObject var membro: Membro
    var comments: [Comentario]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(comments) { comment in
                if !comment.is_question {
                    CommentRow(comentario: comment).environmentObject(self.membro)
                    Divider()
                }
            }
        }
    } //body
}

struct CallQuestions: View {
    @EnvironmentObject var membro: Membro
    var comments: [Comentario]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(comments) { comment in
                if comment.is_question {
                    QuestionRow(comentario: comment).environmentObject(self.membro)
                    Divider()
                }
            }
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
    } //bpdy
}

struct Toggle: View {
    @Binding var questions_on: Bool
    @State var comments_on = false
    @State var questions_color = Color.black
    @State var comments_color = Color.blue
    
    var body: some View {
        VStack {
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
                            self.switchValue(state: self.questions_on)
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
                            self.switchValue(state: self.comments_on)
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
            questions_on.toggle()
            comments_on.toggle()
            if questions_on {
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
