//
//  CategoriesView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    var sala: Sala
    var id_membro: Int
    var membro: Membro { return sala.getMembro(id: id_membro)! }
    @State private var textoPesq: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                SearchBarView(mensagem: "Search for categories")
                
                if sala.categorias.count == 0 {
                    Text("Add a new categorie by adding a new post!")
                        .foregroundColor(Color.gray)
                    
                }
                else{
                    List (sala.categorias){ categ in
                        HStack {
                            // ICON
                            Image(systemName: "command")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                                .font(.system(size: 16, weight: .semibold))
                            
                            // CATEGORIAS E TAGS
                            VStack(alignment: .leading) {
                                NavigationLink(destination: PostsCategorieView(categoria: categ, sala: self.sala)) {
                                    Text(categ.nome)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                }
                                
                                TagsView(tags: categ.tags)
                            }
                        } //HStack
                    } //List
                    .navigationBarTitle(Text("Categories"))
                } //else
            } //VStack
        } //NavigationView
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(sala: DAO().salas[0], id_membro: 1)
    }
}

struct TagsView: View {
    var tags: [Tag]
    
    var body: some View {
        HStack(){
            ForEach(tags){ tag in
                Text(tag.nome)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
            }
        } //HStack
    } //body
}
