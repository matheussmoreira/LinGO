//
//  FYCardView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct FYCardView: View {
    var body: some View {
        
        ZStack {
            //Card
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.white)
                .frame(height: 260)
                .padding()
            
            VStack {
                HStack {
                    //Name of the Category
                    Text("Category")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    //Shared by \(someone)
                    Text("Shared by Fulano")
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                    
                    //English Level
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundColor(.blue)
                    
                } .padding(.horizontal, 32)
                
                VStack(alignment: .leading) {
                    //Title of the post
                    Text("Title")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                        .font(.system(.title, design: .rounded))
                        .lineLimit(2)
                    
                    HStack {
                        //Text of the post
                        Text("Text of the post.")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .frame(height: 190.0)
                
                //Related Tags
                HStack {
                    Text("#Tags")
                        .foregroundColor(Color.blue)
                        .lineLimit(1)
                    
                    Spacer()
                } .padding(.horizontal, 32)
            }
        }
        .shadow(radius: 15)
    }
}

struct FYCardView_Previews: PreviewProvider {
    static var previews: some View {
        FYCardView()
    }
}
