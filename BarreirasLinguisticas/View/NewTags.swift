//
//  NewTags.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
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
            .padding(.bottom)
            .overlay(
                Text(nome)
                    .foregroundColor(.white)
                    .padding(.bottom)
            )
    } //body
}

struct NewTags_Previews: PreviewProvider {
    static var previews: some View {
        NewTags(nome: "Tag")
    }
}
