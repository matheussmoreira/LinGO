//
//  CategoriesView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var dao: DAO
    @State private var textoPesq: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                SearchBarView(mensagem: "Search for categories")
                
                List (dao.categorias){ categ in
                    HStack {
                        // ICON
                        Image(systemName: "command")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        // CATEGORIAS E TAGS
                        VStack(alignment: .leading) {
                            NavigationLink(destination: PostsCategorieView(categorie: categ.id, categorie_name: categ.nome)) {
                                Text(categ.nome)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            }
                            
                            TagsView(tags: categ.tags)
                        }
                    }
                } //List
                .navigationBarTitle(Text("Categories"))
            } //VStack
        } //NavigationView
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
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
        }
    } //body
}
