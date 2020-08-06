//
//  CommentRow.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentRow: View {
    var body: some View {
        
        
        ZStack {
            
           /*RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 80)
                .shadow(radius: 8)
                .padding()
            */
            VStack {
                HStack {
                    Image("foto_leo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40.0, height: 40.0)
                        .clipShape(Circle())
                        .padding(.leading)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Leonardo da Vinci")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(1)
                            
                            Spacer()
                            Text("English Level")
                                .foregroundColor(.gray)
                                .font(.footnote)
                            Circle()
                                .frame(width: 10.0, height: 10.0)
                                .padding(.trailing)
                        }
                        Text("Apple Developer Academy | PUC-Rio | Brazil")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                    } //VStack
                } //HStack
              
                Text("We are the world, we are the children... we are the ones who make a brighter day, so lets got given. That's a choice we're making, to be saving our own lives.")
                    .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .frame(height: 100.0)
                        
            } //VStack
            .padding(.horizontal)
        }//ZStack
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow()
    }
}
