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
        VStack {
            if sala.categorias.count == 0 {
                VStack {
                    HStack {
                        Text("Categories")
                            .font(.system(.largeTitle, design: .rounded))
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
            else {
                HStack {
                    Text("Categories")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }
                
                SearchBarView(mensagem: "Search for categories")
                
                //MARK: - LIST
                List (sala.categorias){ categ in
                    HStack {
                        // ICON
                        Image(systemName: "arrow.turn.down.right")
                            .imageScale(.medium)
                            .foregroundColor(.blue)
                        
                        // CATEGORIAS E TAGS
                        VStack(alignment: .leading) {
                            NavigationLink(destination: PostsCategorieView(categoria: categ, sala: self.sala)) {
                                Text(categ.nome)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 10.0)
                                    .padding(.top, 5.0)
                                
                            } //BOTAR O TITLE
                            if categ.tags.count == 0 {
                                Text("No tags")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            else {
                                TagsView(tags: categ.tags)
                                .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 4)
                    } //HStack
                    
                }//List
                //.navigationBarTitle(Text("Categories"))
                
            } //else
        } //VStack
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
                Text("\(tag.nome) /")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
            }
        } //HStack
    } //body
}
