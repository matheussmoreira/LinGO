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
    @ObservedObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State var textHeight: CGFloat = 150
    @State var description: String = ""
    @State var title: String = ""
    @State var link: String = ""
    @State var tag: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Select a category")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                
                TextField("What is the subject?", text: $title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.bottom)
                
                ScrollView {
                    MultilineTextField(placeholder: "", text: self.$description, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                        .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                }
                
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
                    
                    TextField("Add tags! Eg.: ''SwiftUI, UX, English'' etc. ", text: $tag)
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                }
                .padding(.bottom)
                
                Spacer()
            } //VStack
                .padding()
                .navigationBarTitle(Text("Create a post!"))
                .font(.system(.largeTitle, design: .rounded))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.publica(id_membro: self.membro.usuario.id, titulo: self.title, descricao: self.description, linkString: self.link, categs: [4], tags: [])
                    }){
                        Text("Go!")
                            .bold()
                            .font(.title)
                            .foregroundColor(.blue)
                    }
            )
        } //NavigationView
    } //body
    
    func publica(id_membro: Int, titulo: String, descricao: String?, linkString: String, categs: [Int], tags: [Int]){
        
        if (titulo == "") {
            print("The post needs a title!")
        }
        else {
            if (descricao == "" && linkString == "") {
                print("The post need a description text or an embeded link!")
            }
            else {
                sala.novoPost(publicador: id_membro, post: UUID().hashValue, titulo: titulo, descricao: descricao, link: Link(urlString: linkString), categs: categs, tags: tags)
                
                title = ""; description = ""; link = ""
                
                print("Created the post!")
            }
        }
    }
}

struct PostEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditorView(sala: DAO().salas[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
