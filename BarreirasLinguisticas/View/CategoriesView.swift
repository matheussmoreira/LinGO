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
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @State private var mensagem = ""
    @State private var showRooms = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                if sala.categorias.count == 0 {
                    VStack {
                        Spacer()
                        Text("Add a new categorie by adding a new post!")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
                else {
                    //MARK: - LIST
                    List (sala.categorias.sorted(by: { $0.nome < $1.nome })){ categ in
                        HStack {
                            // ICON
                            Image(systemName: "lightbulb")
                                .imageScale(.medium)
                                .foregroundColor(.yellow)
                            
                            // CATEGORIAS E TAGS
                            VStack(alignment: .leading) {
                                NavigationLink(destination: PostsCategorieView(categoria: categ, sala: self.sala).environmentObject(self.membro)) {
                                    Text(categ.nome)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .frame(height: 10.0)
                                        .padding(.top, 5.0)
                                    
                                }
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
                    
                } //else
            } //VStack
                .navigationBarTitle(Text("Categories"))
                .navigationBarItems(
                    leading:
                    Button(action: {self.showRooms.toggle()}) {
                        Image(systemName: "arrow.uturn.left")
                            .imageScale(.large)
                            .foregroundColor(LingoColors.lingoBlue)
                        }
                    .sheet(isPresented: $showRooms) {
                        RoomsView(usuario: self.membro.usuario)
                            .environmentObject(self.dao)
                    },
                    trailing:
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .foregroundColor(LingoColors.lingoBlue)
                        EditButton()
                            .padding(.leading)
                            .foregroundColor(LingoColors.lingoBlue)
                        
                })
        } // NavigationView
    }// body
    
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView().environmentObject(DAO().salas[0].membros[0])
    }
}

struct TagsView: View {
    var tags: [Tag]
    
    var body: some View {
        HStack(){
            ForEach(tags){ tag in
                Text("\(tag.nome) /")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        } //HStack
    } //body
}
