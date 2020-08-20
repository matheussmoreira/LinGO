//
//  PostEditorView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import UIKit

struct PostEditorView: View {
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
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Select a category")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.systemGray2))
                    
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(LingoColors.lingoBlue)
                        .imageScale(.large)
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
                
                sala.novoPost(publicador: id_membro, post: UUID().hashValue, titulo: titulo, descricao: descricao, link: Link(urlString: linkString), categs: categs, tags: tags)
                
                title = ""; description = ""; link = ""
                
                self.hideKeyboard()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
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
        PostEditorView().environmentObject(DAO().salas[0].membros[0])
    }
}
