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
                print("Buscando o usuario atual...")
                CKManager.fetchUsuario(recordName: recordID.recordName) { (result) in
                    switch result{
                        case .success(let fetchedUser):
                            DispatchQueue.main.async {
                                print("Usuario atual resgatado com sucesso!\n")
                                dao.usuarioAtual = fetchedUser
                                carregaSalaAtual(
                                    id_sala: fetchedUser.sala_atual,
                                    id_usuario: fetchedUser.id
                                )
                                carregaEnterMode()
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
    
    func carregaSalaAtual(id_sala: String?, id_usuario: String){
        print("Botou pra carregar sala atual")
        if let record = dao.getSalaRecord(from: id_sala) {
            Sala.ckLoad(from: record, isSalaAtual: true) { (sala) in
                dao.idSalaAtual = id_sala
                dao.salaAtual = sala
                
                if !dao.salas.contains(sala!) {
                    DispatchQueue.main.async {
                        dao.salas.append(sala!)
                        if dao.salas.count == dao.salasRecords.count {
                            dao.allSalasLoaded = true
                        }
                    }
                }
                
                if let membro = dao.salaAtual!.getMembroByUser(id: id_usuario) {
                    membro.usuario = dao.usuarioAtual!
                    dao.membroAtual = membro
                }
            }
        }
        loading = false
        print("Sala atual carregada: \(String(describing: dao.salaAtual?.nome))")
        dao.ckLoadAllSalas()
    }
    
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
