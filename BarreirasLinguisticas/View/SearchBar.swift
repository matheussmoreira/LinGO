//
//  SearchBar.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 29/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @State var textoPesq: String = ""
    var mensagem: String
    var body: some View {
        TextField(mensagem, text: $textoPesq)
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .padding(.leading)
            .padding(.bottom)
            .padding(.trailing)
            .animation(.default)
    } //body
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(mensagem: "Search for")
    }
}
