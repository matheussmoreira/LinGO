//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        VStack {
            // Topico For you
            HStack {
                Text("For you")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .padding(.top, 50)
                Spacer()
            }
            
            SearchBar()
            
            // Posts For you
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20){
                    ForEach(dao.posts){ post in
                        Button(action: { print("Clicou!") }, label: { FYCardView(post: post)
                        })
                    }
                }
            }
            
            // Topico Recent posts
            HStack {
                Text("Recent posts")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            // Posts Recent posts
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    ForEach(dao.posts){ post in
                        Button(action: { print("Clicou!") },label: { RecentView(post: post)
                        })
                    }
                }
            }
            
            // Topico New tags
            HStack {
                Text("New tags")
                    .font(.callout)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            // Tags New tags
            
            Spacer()
        }//VStack
    }//body
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct SearchBar: View {
    @State var textoPesq: String = ""
    var body: some View {
        TextField("Search for (??)", text: $textoPesq)
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .padding(.leading)
            .padding(.bottom)
            .padding(.trailing)
            .animation(.default)
    }
}
