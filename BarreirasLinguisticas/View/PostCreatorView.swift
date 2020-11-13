//
//  PostEditorView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import UIKit

struct PostCreatorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @State private var placeholder = "Description"
    @State private var showPlaceholder = true
    @State private var textFieldMinHeight: CGFloat = 80
    @State private var description: String = ""
    @State private var title: String = ""
    @State private var link: String = ""
    @State private var tags: String = ""
    @State private var value: CGFloat = 0
    @State private var selectedCategories: [Categoria] = []
    @State private var showPublicationStatusAlert = false
    @State private var publicationStatus = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // SELECIONAR AS CATEGORIAS
                HStack {
                    if selectedCategories.isEmpty {
                        Text("Select the categories ->")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.systemGray2))
                        
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(self.selectedCategories) { categ in
                                    Text(categ.nome)
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: SelectCategories(
                            selectedCategories: $selectedCategories
                        )
                        .environmentObject(sala)
                    ) {
                        Image(systemName: "plus")
                            .foregroundColor(LingoColors.lingoBlue)
                            .imageScale(.large)
                    }
                } // HStack
                .onTapGesture{
                    self.hideKeyboard()
                    if description == "" {
                        showPlaceholder = true
                    }
                }
                
                TextField("Title", text: $title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.vertical)
                    .onTapGesture {
                        if description == "" {
                            showPlaceholder = true
                        }
                    }
                
                ZStack(alignment: .topLeading){
                    TextEditor(text: self.$description)
                        .onTapGesture {
                            showPlaceholder = false
                        }
                    if showPlaceholder {
                        Text(self.placeholder)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(UIColor.systemGray2))
                            .padding(.top, 5)
                    }
                }
                
                // INSERIR LINK E TAG
                VStack {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("You can paste a related link here",
                                  text: $link
                        )
                        .font(.headline)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if description == "" {
                                showPlaceholder = true
                            }
                        }
                        
                        
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("Add tags!", text: $tags)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if description == "" {
                                    showPlaceholder = true
                                }
                            }
                        
                    }
                    .padding(.bottom)
                }
                .animation(.spring())
                .offset(y: -self.value)
            }//VStack
            .padding(.horizontal)
            //                .navigationBarTitle(Text("New post!"))
            .navigationBarItems(
                leading:
                    Text("New post")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding(.top, 32)
                    .onTapGesture{
                        self.hideKeyboard()
                    },
                trailing:
                    Button(action: {
                        self.publicationStatus = self.publica(
                            id_membro: self.membro.usuario.id,
                            titulo: self.title,
                            descricao: self.description,
                            linkString: self.link,
                            categs: [10],
                            tags: self.tags
                        )
                        self.showPublicationStatusAlert = true
                        
                    }){
                        ZStack {
                            Capsule()
                                .frame(width: 80, height: 40)
                                .foregroundColor(LingoColors.lingoBlue)
                            
                            Text("Go!")
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                            //.colorInvert()
                        }
                    }//ZStack
                    .padding(.top, 32)
                    .alert(isPresented: $showPublicationStatusAlert,
                           content: {
                            Alert(title: Text(publicationStatus),
                                  message: Text(""),
                                  dismissButton: .default(Text("Thanks")) {
                                    if self.publicationStatus == "Success!" {
                                        self.title = ""
                                        self.description = ""
                                        self.link = ""
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                  })
                           })
            )
        } // Navigation View
    } //body
    
    func publica(id_membro: String?, titulo: String, descricao: String?, linkString: String, categs: [Int], tags: String) -> String {
        
        if !selectedCategories.isEmpty{
            if (titulo == "") {
                return "The post needs a title!"
                
            } else {
                if ((descricao == "" || descricao == placeholder) && linkString == "") {
                    return "The post need a description text or an embeded link!"
                    
                } else {
                    sala.preparaNovoPost(
                        publicador: id_membro,
                        titulo: titulo,
                        descricao: descricao,
                        linkString: linkString,
                        categs: getCategsId(),
                        tags: tags
                    )
                    
                    self.hideKeyboard()
                    return "Success!"
                }
            }
        } else {
            return "Select at least one category!"
        }
        
    }
    
    func getCategsId() -> [String] {
        var categsId: [String] = []
        for categ in selectedCategories {
            categsId.append(categ.id) // as categorias existem, logo id eh nao-nulo
        }
        return categsId
    }
}

//struct PostEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCreatorView().environmentObject(DAO().salas[0].membros[0])
//    }
//}

struct SelectCategories: View {
    @EnvironmentObject var sala: Sala
    @Binding var selectedCategories: [Categoria]
    
    var body: some View {
        List {
            ForEach(0..<sala.categorias.count) { idx in
                SelectCategorieRow(
                    isSelected: self.selectedCategories.contains(self.sala.categorias[idx]),
                    idx: idx
                )
                    .environmentObject(self.sala)
                    .onTapGesture {
                        if self.selectedCategories.contains(self.sala.categorias[idx]) {
                            self.selectedCategories.removeAll(where: { $0 == self.sala.categorias[idx]})
                        }
                        else {
                            self.selectedCategories.append(self.sala.categorias[idx])
                        }
                    }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitle(
            Text("Select the categories")
        )
    }
}

struct SelectCategorieRow: View {
    @EnvironmentObject var sala: Sala
    var isSelected: Bool
    var idx: Int
    
    var body: some View {
        HStack {
            Text(self.sala.categorias[idx].nome)
            if self.isSelected {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .renderingMode(.original)
                    .imageScale(.large)
            }
            else {
                Spacer()
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
            }
        }
    }
}
