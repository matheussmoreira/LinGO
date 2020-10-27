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
                self.presentImagePicker = true //essa linha so existe na ausencia de camera
            }.sheet(isPresented: $presentImagePicker){
                ImagePickerView(sourceType: .photoLibrary /*self.presentCamera ? .camera : .photoLibrary*/, image: self.$photoProfile, isPresented: self.$presentImagePicker)
            }
        
        Text("Click to choose a picture")
            .font(.system(.title2, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(.primary)
        
        
        Form {
            Section {
                Text("Your Name")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                TextField("", text: $nome)
            }
            
            Section {
                Text("What is your fluency in English?")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                List(0..<fluencias.count){ idx in
                    Text(fluencias[idx])
                        .onTapGesture {
                            fluenciaSelecionada = idx
                        }
                        .foregroundColor(fluencias[idx] == fluencias[fluenciaSelecionada] ? .blue : .black)
                }
            }
        }
        
        Button(action: {
            if nome != ""{
                let novoUsuario = Usuario(id: UUID().hashValue, email: nil, senha: nil, nome: nome, foto_perfil: self.photoProfile, pais: nil, fluencia_ingles: pegaFluenciaEnum())
                dao.addNovoUsuario(novoUsuario)
                dao.usuario_atual = novoUsuario
                loggedIn = true
            } else {
                showAlertNome = true
            }
            
        }) {
            Text("Create")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .background(Color.white)
                .cornerRadius(5)
        }.alert(isPresented: $showAlertNome, content: {
            Alert(title: Text("You cannot have an empty name!"),message: Text(""),dismissButton: .default(Text("Ok")))
        })
        
    }
    
    func pegaFluenciaEnum() -> fluencia {
        switch fluenciaSelecionada {
            case 0:
                return fluencia.basic
            case 1:
                return fluencia.intermed
            case 2:
                return fluencia.advanced
            default:
                return fluencia.unknown
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(loggedIn: .constant(false))
    }
}
