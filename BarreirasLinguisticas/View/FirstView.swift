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
                ZStack {
                    Color("cardColor")
                        .edgesIgnoringSafeArea(.all)
                    ProgressView("")
                }
                
            } else {
                if daoz.usuarioAtual == nil || enterMode == .logOut {
                    OnboardView(enterMode: $enterMode)
                        .environmentObject(daoz)
                } else {
                    ContentView(
                        enterMode: $enterMode,
                        usuarioAtual: $daoz.usuarioAtual
                    )
                        .environmentObject(daoz)
                }
            }
        }
        .onAppear{
            buscaUsuario()
        }
    } //body
    
    func buscaUsuario(){
        CKMDefault.setRecordTypeFor(type: Usuario.self, recordName: "Users")
        CKMDefault.container.fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                loading = false
                return
            }
            if let recordID = recordID {
                CKManager.fetchUsuario(recordName: recordID.recordName) { (result) in
                    switch result{
                        case .success(let fetchedUser):
                            DispatchQueue.main.async {
                                dao.usuarioAtual = fetchedUser
                                dao.idSalaAtual = fetchedUser.sala_atual
                                carregaEnterMode()
                                loading = false
                                print("Usuario resgatado com sucesso")
                            }
                        case .failure(let error):
                            print("first view: case.failure")
                            print(error)
                            return
                    }
                }
            }
        }
    } // funcao
    
    func carregaEnterMode(){
        let storedEnterMode = UserDefaults.standard.integer(forKey: "LastEnterMode")
        if storedEnterMode == 1 {
            enterMode = .logIn
        } else {
            enterMode = .logOut
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
