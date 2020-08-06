//
//  MyPublishedPosts.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct MyPublishedPosts: View {
    @State var published: [Post]
    
    var body: some View {
        VStack {
            HStack {
                Text("Your published posts")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            
            SearchBarView(mensagem: "Search for your published posts")
            
            if published.count == 0 {
                Spacer()
                Text("You haven't published any post yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(published) { post in
                        NavigationLink(destination: PostView(post: post)) {
                            PostCardView(post: post)
                        }
                    }
                }
            } //else
        } //VStack
    } //body
}

struct MyPublishedPosts_Previews: PreviewProvider {
    static var previews: some View {
        MyPublishedPosts(published: DAO().salas[0].posts)
    }
}
