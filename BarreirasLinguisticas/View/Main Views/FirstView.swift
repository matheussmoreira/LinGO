//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD
import CloudKit

enum LogInSystem: Int {
    case loggedIn = 1
    case loggedOut = -1
}

struct FirstView: View {
    @ObservedObject var daoz = dao
    @State private var logInStatus = LogInSystem.loggedOut
    @State private var getStarted = false
    @State private var loading = true
    @State private var loadingMessage = "Wait a moment!"
    
    var body: some View {
        VStack {
            if loading {
                ZStack {
                    Color("cardColor")
                        .edgesIgnoringSafeArea(.all)
                    ProgressView(loadingMessage)
                }
                
            } else {
                if daoz.usuarioAtual == nil || logInStatus == .loggedOut {
                    OnboardView(logInStatus: $logInStatus)
                        .environmentObject(daoz)
                } else {
                    ContentView(
                        logInStatus: $logInStatus,
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
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error)
                loading = false
                return
            }
            if let recordID = recordID {
                print("Buscando o usuario atual...")
                loadingMessage = "Preparing your user :)"
                CKManager.fetchUsuario(recordName: recordID.recordName) { (result) in
                    switch result{
                        case .success(let fetchedUser):
                            DispatchQueue.main.async {
                                print("Usuario atual resgatado com sucesso!\n")
                                dao.usuarioAtual = fetchedUser
                                loadSalas(
                                    id_sala: fetchedUser.sala_atual,
                                    id_usuario: fetchedUser.id
                                )
                                carregaLogInStatus()
                            }
                        case .failure(let error):
                            print(#function)
                            print(error)
                    }
                }
            }
        }
    } // funcao
    
    func loadSalas(id_sala: String?, id_usuario: String){
//        print("BOTOU PRA CARREGAR A SALA ATUAL")
        print("Buscando salas...")
        if id_sala != nil && !id_sala!.isEmpty {
            loadingMessage = "Loading rooms :)"
            if let record = dao.getSalaRecord(from: id_sala) {
                Sala.ckLoad(from: record) { (sala) in
                    dao.idSalaAtual = id_sala
                    dao.salaAtual = sala
                    
                    DispatchQueue.main.async {
                        dao.salas.append(sala!)
                        if dao.salas.count == dao.salasRecords.count {
                            dao.allSalasLoaded = true
                        }
                    }
                    
                    if let membro = dao.salaAtual!.getMembroByUser(id: id_usuario) {
                        membro.usuario = dao.usuarioAtual!
                        dao.membroAtual = membro
                    }
                    
                    /*  Ambiguidade com o else pq assim garanto que
                        so vou carregar as salas restantes qnd
                        carregar sala atual
                     */
                    stopLoading()
                }
            } else {
                print("Não pegou record da sala atual :(")
                loadSalas(id_sala: id_sala, id_usuario: id_usuario)
            }
        }
        else {
//            print("Entrou no else")
            stopLoading()
        }
    }
    
    private func stopLoading(){
        print("Stopped loading")
        loading = false
//        print("Sala atual carregada: \(String(describing: dao.salaAtual?.nome))")
        dao.ckLoadAllSalasButCurrent()
    }
    
    func carregaLogInStatus(){
        let storedEnterMode = UserDefaults.standard.integer(forKey: "LastEnterMode")
        if storedEnterMode == 1 {
            logInStatus = .loggedIn
        } else {
            logInStatus = .loggedOut
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
