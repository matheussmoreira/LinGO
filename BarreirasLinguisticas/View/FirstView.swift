//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD

enum EnterMode: Int {
    case logIn = 1
    case logOut = -1
}

struct FirstView: View {
    @ObservedObject var daoz = dao
    @State private var enterMode = EnterMode.logOut
    @State private var getStarted = false
    @State private var loading = true
    
    var body: some View {
        VStack {
            if loading {
                Text("Loading...")
            } else{
                if daoz.usuario_atual == nil || enterMode == .logOut {
                    OnboardView(enterMode: $enterMode)
                        .environmentObject(daoz)
                } else {
                    ContentView(
                        enterMode: $enterMode,
                        usuario_atual: $daoz.usuario_atual
                    )
                        .environmentObject(daoz)
                }
            }
        }
        .onAppear{
            carregaUsuario2()
            carregaEnterMode()
        }
    } //body
    
    func carregaUsuario2(){
        CKMDefault.setRecordTypeFor(type: Usuario.self, recordName: "Users")
        CKMDefault.container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                return
            }
            if let recordID = recordID {
                CKManager.ckFetchUsuario(recordName: recordID.recordName) { (result) in
                    switch result{
                        case .success(let fetchedUser):
                            DispatchQueue.main.async {
                                dao.usuario_atual = fetchedUser
                                enterMode = .logIn
                                loading = false
                            }
                        case .failure(let error):
                            print("first view: case.failure")
                            print(error)
                            return
                    }
                }
            }
        }
    }
    
    func carregaUsuario(){
        CKMDefault.setRecordTypeFor(type: Usuario.self, recordName: "Users") // tabela Users do iCloud se torna o Usuario
        CKMDefault.container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                return
            }
            if let recordID = recordID {
                print("recordName: \(recordID.recordName)")
                Usuario.ckLoad(with: recordID.recordName) { result in
                    switch result {
                        case .success(let user):
                            DispatchQueue.main.async {
                                print("carregaUsuario: case.success")
                                if let usuario = user as? Usuario{
                                    print("recordName: \(String(describing: usuario.recordName))")
                                    dao.usuario_atual = usuario
                                    loading = false
                                } else {
                                    print("Usuario nao pode ser carregado")
                                }
                                
                            }
                        case .failure(let error):
                            print("carregaUsuario: case.error")
                            print(error)
                            loading = false
                    }
                }
            }
        }
    } //carregaUsuario
    
    func carregaEnterMode(){
        let storedEnterMode = UserDefaults.standard.integer(forKey: "LastEnterMode")
        if storedEnterMode == 1 {
            enterMode = .logIn
        } else {
            enterMode = .logOut
        }
    } //carregaEnterMode
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
