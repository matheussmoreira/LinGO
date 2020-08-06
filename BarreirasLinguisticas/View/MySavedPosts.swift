//
//  MySavedPosts.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct MySavedPosts: View {
    @State var saved: [Post]
    
    var body: some View {
        VStack {
            HStack {
                Text("Your saved posts")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            SearchBarView(mensagem: "Search for your saved posts")
            
            if saved.count == 0 {
                Spacer()
                Text("You haven't saved any post yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(saved) { post in
                        NavigationLink(destination: PostView(post: post)) {
                            PostCardView(post: post)
                        }
                    }
                }
            } //else
        } //VStack
    } //body
}

struct MySavedPosts_Previews: PreviewProvider {
    static var previews: some View {
        MySavedPosts(saved: DAO().salas[0].posts)
    }
}
