//
//  EditProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 20/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var usuario: Usuario
    //@EnvironmentObject var membro: Membro
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    let fluencias = ["Basic", "Intermediate", "Advanced"]
    
    var body: some View {
        NavigationView {
            VStack {
                Image(usuario.foto_perfil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.primary, lineWidth: 8)
                            .colorInvert()
                            .shadow(radius: 8))
                    .padding(.all, 32)
                
                Form {
                    Section {
                        TextField(usuario.nome, text: $nome)
                        Picker(selection: $fluenciaSelecionada, label: Text("English Level")) {
                            ForEach(0..<fluencias.count) { idx in
                                Text(self.fluencias[idx]).tag(idx)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {self.presentationMode.wrappedValue.dismiss()}){
                    Text("Cancel")
                }
                ,trailing: Button(action: {
                    self.usuario.nome = self.nome
                    switch self.fluenciaSelecionada {
                        case 0: self.usuario.fluencia_ingles = fluencia.basic
                        case 1: self.usuario.fluencia_ingles = fluencia.intermed
                        case 2: self.usuario.fluencia_ingles = fluencia.advanced
                        default: self.usuario.fluencia_ingles = fluencia.unknown
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("Save")
                })
        }.onAppear{
            switch self.usuario.fluencia_ingles {
                case fluencia.basic:
                    self.fluenciaSelecionada = 0
                case fluencia.intermed:
                    self.fluenciaSelecionada = 1
                case fluencia.advanced:
                    self.fluenciaSelecionada = 2
                default:
                    self.fluenciaSelecionada = 0
            }
        } //NavigationView
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(usuario: DAO().usuarios[0])
    }
}