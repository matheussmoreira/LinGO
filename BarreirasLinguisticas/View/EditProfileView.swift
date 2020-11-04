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
    //@State private var presentCamera = false
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    let fluencias = ["Basic", "Intermediate", "Advanced"]
    
    var body: some View {
        NavigationView {
            VStack {
                photoProfile!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.primary, lineWidth: 8)
                            .colorInvert()
                            .shadow(radius: 8))
                    .padding(.all)
                    .onTapGesture {
                        self.presentImageActionScheet.toggle()
                        self.presentImagePicker = true //essa linha so existe na ausencia de camera
                    }.sheet(isPresented: $presentImagePicker){
                        ImagePickerView(
                            sourceType: .photoLibrary /*self.presentCamera ? .camera : .photoLibrary*/,
                            image: self.$photoProfile,
                            isPresented: self.$presentImagePicker
                        )
                    }
                //                    .actionSheet(isPresented: $presentImageActionScheet){
                //                        ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [
                //                            .default(Text("Camera")){
                //                                self.presentImagePicker = true
                //                                self.presentCamera = true
                //                            },
                //                            .default(Text("Photo Library")){
                //                                self.presentImagePicker = true
                //                                self.presentCamera = false
                //                            },
                //                            .cancel()
                //                        ])
                //                    } //actionSheet
                
                Text("Click to choose a picture")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                Form {
                    Section {
                        Text("Your Name")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        TextField(usuario.nome, text: $nome)

                    }
                    
                    Section {
                        Text("English Fluency")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        List(0..<fluencias.count){ idx in
                            Text(fluencias[idx])
                                .onTapGesture {
                                    fluenciaSelecionada = idx
                                    self.hideKeyboard()
                                }
                                .foregroundColor(fluencias[idx] == fluencias[fluenciaSelecionada] ? .blue : .gray)
                        }
                    }
                }
            } //VStack
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Cancel")
                    },
                trailing:
                    Button(action: {
                        editaUsuario2()
                    }){
                        Text("Save")
                    })
        }
        .onAppear {
            self.photoProfile = self.usuario.foto_perfil
//            self.fluenciaSelecionada = Usuario.pegaFluenciaIdx(fluencia: self.usuario.fluencia_ingles)
            self.fluenciaSelecionada = Usuario.pegaFluenciaIdx(fluencia: Usuario.pegaFluencia(nome: self.usuario.fluencia_ingles))
        }
    } //body
    
    mutating func editaUsuario2(){
        let usuarioAtualizado: Usuario
        usuarioAtualizado.id = self.usuario.id
        if self.nome != "" { usuarioAtualizado.nome = self.nome }
        usuarioAtualizado.sala_atual = self.usuario.sala_atual
        usuarioAtualizado.foto_perfil = self.photoProfile ?? self.usuario.foto_perfil
        usuarioAtualizado.fluencia_ingles = Usuario.pegaFluenciaNome(idx: fluenciaSelecionada).rawValue
        
        CKManager.saveUser(user: usuarioAtualizado) { (result) in
            switch result {
                case .success(let savedUser):
                    print("EditProfile case.success")
//                    self.usuario = savedUser
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func editaUsuario(usuario: Usuario){
//        if self.nome != "" { self.usuario.nome = self.nome }
//        self.usuario.foto_perfil = self.photoProfile ?? self.usuario.foto_perfil
////                        self.usuario.fluencia_ingles = Usuario.pegaFluenciaNome(idx: fluenciaSelecionada)
//        self.usuario.fluencia_ingles = Usuario.pegaFluenciaNome(idx: fluenciaSelecionada).rawValue
        
        DispatchQueue.main.async {
            self.usuario.ckSave { (result) in
                switch result{
                    case .success(_):
                        print("EditProfile: case.success")
                    case .failure(let error):
                        print("EditProfile: case.error")
                        print(error)
                }
            }
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(usuario: DAO().usuarios[0])
//    }
//}
