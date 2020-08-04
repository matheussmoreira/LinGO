//
//  PostsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 29/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PostsCategorie: View {
    var posts: Post
    var body: some View {
        Text("Posts View!")
            .fontWeight(.bold)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsCategorie(posts: DAO().posts[0])
    }
}
