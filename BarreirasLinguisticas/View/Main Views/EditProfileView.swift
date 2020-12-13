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
    @State private var foto_perfil: UIImage? = UIImage(named: "perfil")
    @State private var showImagePicker = false
    @State private var showImageActionSheet = false
    //@State private var presentCamera = false
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    let fluencias = ["Basic", "Intermediate", "Advanced"]
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: foto_perfil!)
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
                        self.showImageActionSheet.toggle()
                        self.showImagePicker = true
                        //a linha acima so existe na ausencia de camera
                    }.sheet(isPresented: $showImagePicker){
                        ImagePickerView(
                            image: self.$foto_perfil,
                            isPresented: self.$showImagePicker
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
                        editaUsuario()
                    }){
                        Text("Save")
                    })
        }
        .onAppear {
            self.foto_perfil = self.usuario.foto_perfil?.asUIImage() ?? UIImage(named: "perfil")!
            self.fluenciaSelecionada = Usuario.getIdxByFluencia(
                self.usuario.fluencia_ingles
            )
        }
    } //body
    
    func editaUsuario() {
        usuario.nome = nome == "" ? usuario.nome : nome
        usuario.fluencia_ingles = Usuario.getFluenciaByIdx(fluenciaSelecionada)
        usuario.foto_perfil = foto_perfil?.pngData() ?? usuario.foto_perfil
        
        let url = FileSystem.filePath(forId: usuario.id)
        FileSystem.storeImage(
            data: usuario.foto_perfil,
            url: url,
            forId: usuario.id
        )
        usuario.url_foto = url
        
        dao.usuarioAtual = usuario
        presentationMode.wrappedValue.dismiss()
        CKManager.modifyUsuario(user: usuario)
    }
    
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView(usuario: DAO().usuarios[0])
//    }
//}
