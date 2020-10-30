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
    case signUp = 1
    case logIn = 2
    case none = -1
}

struct FirstView: View {
    @ObservedObject var daoz = dao
    @State private var enterMode = EnterMode.none
    @State private var getStarted = false
    @State private var loading = true
    
    var body: some View {
        VStack {
            if loading {
                Text("Loading...")
            } else{
                if daoz.usuario_atual == nil || enterMode == .none {
                    OnboardView(enterMode: $enterMode)
                } else {
                    ContentView(enterMode: $enterMode, usuario_atual: $daoz.usuario_atual)
                        .environmentObject(dao)
                }
            }
        }
        .onAppear{
            carregaUsuario()
            carregaEnterMode()
        }
    } //body
    
    func carregaUsuario(){
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
                            let usuario = user as? Usuario
                            dao.usuario_atual = usuario
                            loading = false
                        case .failure(let error):
                            print(error)
                    }
                }
            }
        }
    }
    
    func carregaEnterMode(){
        let defaults = UserDefaults.standard
        let storedEnterMode = defaults.integer(forKey: "LastEnterMode")
        switch storedEnterMode {
            case 1:
                enterMode = .signUp
            case 2:
                enterMode = .logIn
            default:
                enterMode = .none
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
