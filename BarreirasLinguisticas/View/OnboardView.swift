//
//  WelcomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKitMagicCRUD

struct OnboardView: View {
    @EnvironmentObject var dao: DAO
    @State private var getStarted = false
    @Binding var enterMode: EnterMode
    var onboardPages = Onboard.getAll
    var body: some View {
        
        VStack {
            // FIGURINHAS
            TabView{
                ForEach(0..<onboardPages.count){ idx in
                    VStack{
                        Image(onboardPages[idx].image)
                            .resizable()
                            .scaledToFit()
                        VStack{
                            Text(onboardPages[idx].heading)
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                                .layoutPriority(1)
                                .multilineTextAlignment(.center)
                            
                            Text(onboardPages[idx].subheading)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            // BOTAO GET STARTED
            Button(action: {carregaUsuario()/*self.getStarted.toggle()*/}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 250.0, height: 40.0)
                        .foregroundColor(.black)
                    
                    Text("Get started")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical)
//            .sheet(isPresented: $getStarted){
//                NavigationView {
//                    EnterView(enterMode: $enterMode)
//                        .environmentObject(dao)
//                        .navigationBarHidden(true)
//                }
//            }
            
        } // VStack
        .background(
            Color("lingoBlueBackground")
                .edgesIgnoringSafeArea(.all)
        )
        
    }//body
    
    func carregaUsuario(){
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
                                dao.sala_atual = fetchedUser.sala_atual
                                enterMode = .logIn
                                UserDefaults.standard.set(
                                    enterMode.rawValue,
                                    forKey: "LastEnterMode"
                                )
                            }
                        case .failure(let error):
                            print(#function)
                            print(error)
                    }
                }
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(enterMode: .constant(.logOut))
    }
}
