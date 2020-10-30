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
    @ObservedObject var daoz = dao //em qualquer lugar do app consigo acessar o dao, mas aqui precisamos ser notificados quanto as alteracoes do dao
    @State private var enterMode = EnterMode.none
    @State private var getStarted = false
    @State private var userId: Int = -1
    
    var body: some View {
        VStack {
            // Tela de loading enquanto busca o usuario
            if userId == 0 || enterMode == .none {
                OnboardView(userId: $userId, enterMode: $enterMode)
            } else {
                ContentView(enterMode: $enterMode)
                    .environmentObject(dao)
            }
        }
        .onAppear{
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
                                //Sala.loadAll e salvar no dao em paralelo ao usuario.ckLoad
                                // ids como string para confomar com o recordName
                                // sala_atual com atributo do usuario
                            case .failure(let error):
                                print(error)
                        }
                    }
                }
            }
            
            let defaults = UserDefaults.standard
//            userId = defaults.string(forKey: "UserId")
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
    } //body
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
