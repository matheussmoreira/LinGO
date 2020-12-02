//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD

enum LogInSystem: Int {
    case loggedIn = 1
    case loggedOut = -1
}

struct FirstView: View {
    @ObservedObject var daoz = dao
    @State private var logInStatus = LogInSystem.loggedOut
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
                if daoz.usuarioAtual == nil || logInStatus == .loggedOut {
                    OnboardView(logInStatus: $logInStatus)
                        .environmentObject(daoz)
                        .onAppear{
                            print("Carregou onboard!")
                        }
                } else {
                    ContentView(
                        logInStatus: $logInStatus,
                        usuarioAtual: $daoz.usuarioAtual
                    )
                    .environmentObject(daoz)
                    .onAppear{
                        print("Entrou na sala!")
                    }
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
                                carregaLogInStatus()
                            }
                        case .failure(let error):
                            print(#function)
                            fatalError(error.asString)
                    }
                }
            }
        }
    } // funcao
    
    func carregaSalaAtual(id_sala: String?, id_usuario: String){
        print("BOTOU PRA CARREGAR A SALA ATUAL")
        if let record = dao.getSalaRecord(from: id_sala) {
            Sala.ckLoad(from: record) { (sala) in
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
