//
//  NewUserView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    //    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @Binding var enterMode: EnterMode
    @State private var photoProfile: Image? = Image("perfil")
    @State private var presentImagePicker = false
    @State private var presentImageActionScheet = false
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    @State private var showAlertNome = false
    let fluencias = ["Basic","Intermediate", "Advanced"]
    
    var body: some View {
        VStack{
            //FOTO DE PERFIL
            photoProfile!
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150.0, height: 150.0)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.primary, lineWidth: 8)
                        .colorInvert()
                        .shadow(radius: 8))
                .padding(.all)
                .onTapGesture {
                    self.presentImageActionScheet.toggle()
                    self.presentImagePicker = true //essa linha so existe na ausencia de camera
                }
                .sheet(isPresented: $presentImagePicker) {
                    ImagePickerView(
                        sourceType: .photoLibrary /*self.presentCamera ? .camera : .photoLibrary*/,
                        image: self.$photoProfile,
                        isPresented: self.$presentImagePicker)
                }
            
            Text("Click to choose a picture")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .onTapGesture{
                    self.hideKeyboard()
                }
            
            // FORMULARIO
            Form {
                Section {
                    Text("Your Name")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .onTapGesture{
                            self.hideKeyboard()
                        }
                    TextField("", text: $nome)
                }
                
                Section {
                    Text("What is your fluency in English?")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .onTapGesture{
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
            } //Form
            .padding(.vertical)
            
            Spacer()
        }
        .navigationBarTitle("Create your profile", displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    novoUsuario2()
                }) {
                    
                    Text("Create")
                }
                .alert(
                    isPresented: $showAlertNome,
                    content: {
                        Alert(
                            title: Text("You cannot have an empty name!"),
                            message: Text(""),
                            dismissButton: .default(Text("Ok"))
                        )
                    })
        )
        
    } //body
    
    func novoUsuario2(){
        let usuarioAtualizado = Usuario(
            nome: (self.nome != "") ? self.nome : nil,
            foto_perfil: self.photoProfile,
            fluencia_ingles: Usuario.pegaFluenciaNome(idx: fluenciaSelecionada))
        
        CKManager.ckSaveUsuario(user: usuarioAtualizado) { (result) in
            switch result {
                case .success(let savedUser):
                    DispatchQueue.main.async {
                        print("NewUser: case.success")
                        dao.addNovoUsuario(savedUser)
                        dao.usuario_atual = savedUser
                        enterMode = .logIn
                        UserDefaults.standard.set(
                            enterMode.rawValue,
                            forKey: "LastEnterMode"
                        )
                    }
                case .failure(let error):
                    print("NewUser: case.failure")
                    print(error)
            }
        }
    }
    
    func novoUsuario(){
        if nome != "" {
            let novoUsuario = Usuario(
                nome: nome,
                foto_perfil: self.photoProfile,
                fluencia_ingles: Usuario.pegaFluenciaNome(idx: fluenciaSelecionada)
            )
            novoUsuario.ckSave { (result) in
                switch result {
                    case .success(let savedUser):
                        DispatchQueue.main.async {
                            print("NewUser: case.success")
                            dao.addNovoUsuario(savedUser as? Usuario)
                            dao.usuario_atual = savedUser as? Usuario
                            enterMode = .logIn
                            UserDefaults.standard.set(
                                enterMode.rawValue,
                                forKey: "LastEnterMode"
                            )
                        }
                    case .failure(let error):
                        print("NewUser: case.error")
                        print(error)
                }
            }
            
        } else {
            showAlertNome = true
        }
    } // novoUsuario
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(enterMode: .constant(.logOut))
    }
}
