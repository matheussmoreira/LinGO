//
//  NewUserView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    @EnvironmentObject var dao: DAO
    @State private var photoProfile: Image? = Image("perfil")
    @State private var presentImagePicker = false
    @State private var presentImageActionScheet = false
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    @State private var showAlertNome = false
    @Binding var loggedIn: Bool
    let fluencias = ["Basic","Intermediate", "Advanced"]
    
    
    var body: some View {
        Text("Create your profile")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .font(.title)
            .padding(.top)
        
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
            .padding(.all, 32)
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
        }
        
        Button(action: {
            if nome != "" {
                let novoUsuario = Usuario(id: UUID().hashValue, email: nil, senha: nil, nome: nome, foto_perfil: self.photoProfile, pais: nil, fluencia_ingles: Usuario.pegaFluenciaNome(idx: fluenciaSelecionada))
                
                dao.addNovoUsuario(novoUsuario)
                dao.usuario_atual = novoUsuario
                loggedIn = true
            } else {
                showAlertNome = true
            }
            
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 250.0, height: 40.0)
                    .foregroundColor(Color("lingoBlueBackgroundInverted"))
                
                Text("Create")
                    .foregroundColor(.white)
                    
            }
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
        .padding(.vertical)
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(loggedIn: .constant(false))
    }
}
