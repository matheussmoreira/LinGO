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
    @State private var photoProfile: Image? = Image("perfil")
    @State private var presentImagePicker = false
    @State private var presentImageActionScheet = false
    @State private var presentCamera = false
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    let fluencias = ["Basic", "Intermediate", "Advanced"]
    
    var body: some View {
        NavigationView {
            VStack {
                //Image(usuario.foto_perfil)
                photoProfile!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.primary, lineWidth: 8)
                            .colorInvert()
                            .shadow(radius: 8))
                    .padding(.all, 32)
                    .onTapGesture {
                        self.presentImageActionScheet.toggle()
                    }.sheet(isPresented: $presentImagePicker){
                        ImagePickerView(sourceType: self.presentCamera ? .camera : .photoLibrary, image: self.$photoProfile, isPresented: self.$presentImagePicker)
                    }
                    .actionSheet(isPresented: $presentImageActionScheet){
                        ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [
                            .default(Text("Camera")){
                                self.presentImagePicker = true
                                self.presentCamera = true
                            },
                            .default(Text("Photo Library")){
                                self.presentImagePicker = true
                                self.presentCamera = false
                            },
                            .cancel()
                        ])
                    } //actionSheet
                
                Text("Click to choose a picture")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
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
            } //VStack
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {self.presentationMode.wrappedValue.dismiss()}){
                    Text("Cancel")
                }
                ,trailing: Button(action: {
                    if self.nome != "" {self.usuario.nome = self.nome}
                    self.usuario.foto_perfil = self.photoProfile ?? self.usuario.foto_perfil
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
            self.photoProfile = self.usuario.foto_perfil
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
