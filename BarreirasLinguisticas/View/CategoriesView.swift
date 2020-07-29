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
    @State var textoPesq: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                // Search bar
                TextField("Search for (??)", text: $textoPesq)
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    .padding()
                    .animation(.default)
                
                CategorieView(dao: dao)
            }
        }
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

struct CategorieView: View {
    var dao: DAO
    var body: some View {
        List (dao.categorias){ categ in
            HStack {
                Image(systemName: "command")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .font(.system(size: 16, weight: .semibold))
                
                VStack(alignment: .leading) {
                    Text(categ.nome)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    
                    TagsView(tags: categ.tags)
                }
            }
        }
        .navigationBarTitle(Text("Categories"))
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
