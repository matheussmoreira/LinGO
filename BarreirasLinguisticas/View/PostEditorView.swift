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
    @State private var textFieldMinHeight: CGFloat = 80
    @State private var description: String = ""
    @State private var title: String = ""
    @State private var link: String = ""
    @State private var tags: String = ""
    @State private var value: CGFloat = 0
    @State private var selectedCategories: [Categoria] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if selectedCategories.isEmpty {
                        Text("Select a category")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color(UIColor.systemGray2))
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(self.selectedCategories) { categ in
                                    Text(categ.nome)
                                        .font(.system(.title, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SelectCategories(selectedCategories: $selectedCategories).environmentObject(sala)) {
                        Image(systemName: "plus")
                            .foregroundColor(LingoColors.lingoBlue)
                            .imageScale(.large)
                    }
                }
                
                TextField("Title here", text: $title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom)
                
                ScrollView {
                    MultilineTextField(placeholder: placeholder, text: self.$description, minHeight: self.textFieldMinHeight, calculatedHeight: self.$textFieldMinHeight)
                        .frame(minHeight: self.textFieldMinHeight, maxHeight: self.textFieldMinHeight)
                }
                
                VStack {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("You can paste a related link here", text: $link)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("Add tags! Eg.: ''SwiftUI, UX, English'' etc. ", text: $tags)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .autocapitalization(.allCharacters)
                        
                    }
                    .padding(.bottom)
                }
                .animation(.spring())
                .offset(y: -self.value)
                .onAppear {
                    self.ajustaAltura()
                }
            }//VStack
                .padding()
                .navigationBarTitle(Text("New post!"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.publica(id_membro: self.membro.usuario.id, titulo: self.title, descricao: self.description, linkString: self.link, categs: [10], tags: self.tags)
                        
                    }){
                        ZStack {
                            Capsule()
                                .frame(width: 90, height: 50)
                                .foregroundColor(LingoColors.lingoBlue)
                            Text("Go!")
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                            //.colorInvert()
                        }
                    }//ZStack
                        .padding(.top, 32)
            )
        } //NavigationView
    } //body
    
    func publica(id_membro: Int, titulo: String, descricao: String?, linkString: String, categs: [Int], tags: String){
        
        if (titulo == "") {
            print("The post needs a title!")
        }
        else {
            if ((descricao == "" || descricao == placeholder) && linkString == "") {
                print("The post need a description text or an embeded link!")
            }
            else {
                
                sala.novoPost(publicador: id_membro, post: UUID().hashValue, titulo: titulo, descricao: descricao, link: Link(urlString: linkString), categs: getCategsId(), tags: tags)
                
                title = ""; description = ""; link = ""
                
                self.hideKeyboard()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func getCategsId() -> [Int] {
        var categsId: [Int] = []
        for categ in selectedCategories {
            categsId.append(categ.id)
        }
        return categsId
    }
    
    func ajustaAltura() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ (noti) in
            
            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let height = value.height
            self.value = height-50
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
            self.value = 0
        }
    }
}

struct PostEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostCreatorView().environmentObject(DAO().salas[0].membros[0])
    }
}

struct SelectCategories: View {
    @EnvironmentObject var sala: Sala
    @Binding var selectedCategories: [Categoria]
    
    var body: some View {
        List {
            ForEach(0..<sala.categorias.count) { idx in
                SelectCategorieRow(isSelected: self.selectedCategories.contains(self.sala.categorias[idx]), idx: idx).environmentObject(self.sala)
                    .onTapGesture {
                        
                        if self.selectedCategories.contains(self.sala.categorias[idx]) {
                            self.selectedCategories.removeAll(where: { $0 == self.sala.categorias[idx]})
                        }
                        else {
                            self.selectedCategories.append(self.sala.categorias[idx])
                        }
                }
            }
        }.navigationBarTitle(
            Text("Select the categories")
                .font(.system(.title, design: .rounded)),displayMode: .inline
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
                Image(systemName: "checkmark")
            }
        }
    }
}
