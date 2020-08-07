//
//  CommentsQuestionsToggle.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 07/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentsQuestionsToggle: View {
    var body: some View {
        ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.clear)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                
            HStack {
                HStack {
                    Image(systemName: "bubble.left")
                    Text("Comments")
                        .font(.headline)
                }
                .padding(.horizontal, 32)
                Divider()
                HStack {
                    Image(systemName: "questionmark.circle")
                    Text("Questions")
                        .font(.headline)
                }
                .padding(.horizontal, 32)
            }
            
            }
            .frame(height: 70.0)
        .padding()    }
}

struct CommentsQuestionsToggle_Previews: PreviewProvider {
    static var previews: some View {
        CommentsQuestionsToggle()
    }
}
