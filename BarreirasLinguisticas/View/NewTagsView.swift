//
//  NewTagsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 28/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct NewTagsView: View {
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
    } //body
}

struct NewTagsView_Previews: PreviewProvider {
    static var previews: some View {
        NewTagsView(nome: "Tag")
    }
}
