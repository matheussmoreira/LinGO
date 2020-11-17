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
    @EnvironmentObject var dao: DAO
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
            self.photoProfile = Image(uiImage: self.usuario.foto_perfil?.asUIImage() ?? UIImage(named: "perfil")!)
            self.fluenciaSelecionada = Usuario.pegaFluenciaIdx(fluencia: Usuario.pegaFluencia(nome: self.usuario.fluencia_ingles))
        }
    } //body
    
    func editaUsuario2() {
        self.usuario.nome = self.nome == "" ? self.usuario.nome : self.nome
        self.usuario.fluencia_ingles = Usuario.pegaFluenciaNome(idx: fluenciaSelecionada).rawValue
        self.usuario.foto_perfil = self.photoProfile?.asUIImage().pngData() ?? self.usuario.foto_perfil
        
        dao.usuario_atual = self.usuario
        dao.editaPublicadores(usuario: self.usuario)
        self.presentationMode.wrappedValue.dismiss()
        
        CKManager.modifyUsuario(user: self.usuario) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        print("editaUsuario: case.success")
                    }
                case .failure(let error):
                    print("editaUsuario: case.error")
                    print(error)
            }
        }
    }
    
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(usuario: DAO().usuarios[0])
//    }
//}
