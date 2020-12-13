//
//  CommentsQuestionsToggle.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 07/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CQToggle: View {
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @ObservedObject var post: Post
    @State private var questions_selected = true
    @State private var comments_selected = false
    @State private var questions_color = Color.primary
    @State private var comments_color = Color.blue
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top)
            
            // MARK: - TOGLLE BAR
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.clear)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: UIScreen.width-20)
                    
                    HStack {
                        HStack {
                            Button(action: {
                                switchValue(state: questions_selected)
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
                                self.switchValue(state: comments_selected)
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
            
            if questions_selected {
                QuestionsList(post: post)
                    .environmentObject(membro)
                    .environmentObject(sala)
            }
            else {
                CommentsList(post: post)
                    .environmentObject(membro)
                    .environmentObject(sala)
            }
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
    }
    
}

//struct CommentsQuestionsToggle_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsQuestionsToggle(post: DAO().salas[0].posts[0])
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
