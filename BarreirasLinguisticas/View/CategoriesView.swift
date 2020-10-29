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
    @State private var showCriaCategoria = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                if sala.categorias.isEmpty {
                    VStack {
                        Spacer()
                        Text("There are no categories yet 😕")
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
                                NavigationLink(destination: PostsOfCategorieView(categoria: categ, sala: self.sala).environmentObject(self.membro)) {
                                    Text(categ.nome)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .frame(height: 10.0)
                                        .padding(.top, 5.0)
                                    
                                }
                                if categ.tagsPosts.isEmpty {
                                    Text("No related tags")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                        .multilineTextAlignment(.leading)
                                }
                                else {
                                    HStack {
                                        ForEach(0..<categ.tagsPosts.count) { idx in
                                            Text(categ.tagsPosts[idx])
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarTitle(Text("Categories"))
            .navigationBarItems(
                leading:
                    Button(action: {self.showRooms.toggle()}) {
                        Image(systemName: "rectangle.grid.1x2")
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
//                        EditButton()
//                            .padding(.leading)
//                            .foregroundColor(LingoColors.lingoBlue)
                        Button(action: {showCriaCategoria.toggle()}) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .foregroundColor(LingoColors.lingoBlue)
                                .padding(.leading)
                        }
                        .sheet(
                            isPresented: $showCriaCategoria,
                            content: {
                                CreateCategorieView()
                                    .environmentObject(sala)
                            })
                    })
        }
    } //body
    
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView().environmentObject(DAO().salas[0].membros[0])
    }
}

struct CreateCategorieView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sala: Sala
    @State private var newCategoryName = ""
    
    var body: some View {
        VStack {
            Text("Create a new category!")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Name",text: $newCategoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: UIScreen.width*0.85)
                .padding(.bottom)
  
            Button(action: {
                if newCategoryName != "" && newCategoryName != " " {
                    sala.novaCategoria(id: UUID().hashValue, nome: newCategoryName)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    Text("Save")
                        .foregroundColor(.white)
                }
            }
        }
    } //body
}
