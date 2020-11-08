//
//  EnterView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 27/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD

struct EnterView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @Binding var enterMode: EnterMode
    
    var body: some View {
        VStack{
            // TRACINHO DO MODAL
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top)
            
            Spacer()
            
            Text("What do you want to do?")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            
            // LOGIN
            Button(action: {
                logIn2()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    
                    Text("Log-in")
                        .foregroundColor(.white)
                }
            }
            
            // NOVO USUARIO
            NavigationLink(
                destination:
                    NewUserView(enterMode: $enterMode)
                        .environmentObject(dao)
                        .navigationBarHidden(false)
            ){
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(LingoColors.lingoBlue)
                    
                    Text("Create a new account")
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        
    } // body
    
    func logIn2(){
        CKMDefault.setRecordTypeFor(type: Usuario.self, recordName: "Users")
        CKMDefault.container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                return
            }
            if let recordID = recordID {
                CKManager.fetchUsuario(recordName: recordID.recordName) { (result) in
                    switch result{
                        case .success(let fetchedUser):
                            DispatchQueue.main.async {
                                print("login: case.success")
                                dao.usuario_atual = fetchedUser
                                dao.sala_atual = fetchedUser.sala_atual
                                enterMode = .logIn
                                UserDefaults.standard.set(
                                    enterMode.rawValue,
                                    forKey: "LastEnterMode"
                                )
                            }
                        case .failure(let error):
                            print("login: case.failure")
                            print(error)
                    }
                }
            }
        }
    }
    
    func logIn(){
        CKMDefault.setRecordTypeFor(type: Usuario.self, recordName: "Users") // tabela Users do iCloud se torna o Usuario
        CKMDefault.container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                return
            }
            if let recordID = recordID {
                Usuario.ckLoad(with: recordID.recordName) { result in
                    switch result {
                        case .success(let user):
                            DispatchQueue.main.async {
                                print("login: case.success")
                                let usuario = user as? Usuario
                                print("recordName: \(String(describing: usuario?.recordName))")
                                dao.usuario_atual = usuario
                                enterMode = .logIn
                                UserDefaults.standard.set(
                                    enterMode.rawValue,
                                    forKey: "LastEnterMode"
                                )
                            }
                        case .failure(let error):
                            print("login: case.failure")
                            print(error)
                    }
                }
            }
        }
    } //logIn
}

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView(enterMode: .constant(.logOut))
    }
}
