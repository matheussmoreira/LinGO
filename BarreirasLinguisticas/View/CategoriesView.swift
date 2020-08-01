//
//  CategoriesView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @ObservedObject var sala: Sala
    @ObservedObject var membro: Membro
    @State private var textoPesq: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                if sala.categorias.count == 0 {
                    VStack {
                        HStack {
                            Text("Categories")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                        }
                        SearchBarView(mensagem: "Search for categories")
                        Spacer()
                        Text("Add a new categorie by adding a new post!")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    
                }
                else{
                    SearchBarView(mensagem: "Search for categories")
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
        CategoriesView(sala: DAO().salas[0],  membro: DAO().salas[0].membros[0])
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
