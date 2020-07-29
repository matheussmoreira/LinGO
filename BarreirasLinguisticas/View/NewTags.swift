//
//  NewTags.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct NewTags: View {
    var nome: String
    var body: some View {
        RoundedRectangle(cornerRadius: 45)
            .fill(Color.blue)
            .frame(height: 40)
            .frame(width: 200)
            .overlay(
                Text(nome)
                    .foregroundColor(.white)
            )
    }
}

struct NewTags_Previews: PreviewProvider {
    static var previews: some View {
        NewTags(nome: DAO().posts[0].tags[0].nome)
    }
}
