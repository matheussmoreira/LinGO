//
//  ProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    @Binding var enterMode: EnterMode
    @State private var showRooms = false
    @State private var showAlertLeave = false
    @State private var showAlertLogOut = false
    @State private var showEditProfile = false
    @State private var showAdminSheet = false
    @State private var nome: String = ""
    @State private var foto: Data?
    @State private var fluencia: String = ""
    
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .padding(.bottom, -100.0)
                    .padding(.top, -1150)
                    .frame(width: 600.0, height: 600.0)
                    .foregroundColor(LingoColors.lingoBlue)
                
                //MARK: - DADOS DO MEMBRO
                VStack {
                    Image(uiImage: membro.usuario.foto_perfil?.asUIImage() ?? UIImage(named: "perfil")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150.0, height: 150.0)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 8)
                                .colorInvert()
                        )
                    
                    Text(nome)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                    
                    HStack {
                        Text(membro.usuario.fluencia_ingles)
                            .foregroundColor(Color.gray)
                        Circle()
                            .fill(membro.usuario.cor_fluencia)
                            .frame(width: 15.0, height: 15.0)
                    }
                    
                    Text(sala.nome)
                        .foregroundColor(Color.gray)
                    
                    //MARK: - POSTS PUBLICADOS
                    ScrollView(.vertical, showsIndicators: false) {
                        NavigationLink(destination:
                                        MyPublications(sala: sala).environmentObject(membro)) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("My publications")
                                        .foregroundColor(.white)
                                )
                        }
                        
                        //MARK: - POSTS SALVOS
                        NavigationLink(destination:
                                        MySavedPosts(sala:sala).environmentObject(membro)) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("My saved posts")
                                        .foregroundColor(.white)
                                )
                        }
                        
                        //MARK: - ASSINATURAS
                        NavigationLink(
                            destination: SubscriptionsView(sala: sala)
                                .environmentObject(membro)
                        ) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("My subscriptions")
                                        .foregroundColor(.white)
                                )
                        }
                        
                        //MARK: - MEMBROS DA SALA
                        NavigationLink(
                            destination:RoomMembersView(membro: membro, sala: sala)
                        ){
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("Members of this room")
                                        .foregroundColor(.white)
                                )
                        }
                        
                        //MARK: - FUNCOES ADMIN
                        if(membro.isAdmin) {
                            Button(action: {self.showAdminSheet.toggle()}){
                                RoundedRectangle(cornerRadius: corner)
                                    .foregroundColor(lingoBlue)
                                    .frame(height: btn_height)
                                    .frame(width: btn_width)
                                    .overlay(
                                        Text("Admin")
                                            .foregroundColor(.white)
                                    )
                            }
                            .sheet(isPresented: $showAdminSheet) {
                                if !membro.isBlocked {
                                    AdminView()
                                        .environmentObject(self.sala)
                                        .environmentObject(self.membro)
                                } else {
                                    Text("You cannot make admin actions\nbecause you are blocked")
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        
                        //MARK: - LEAVE ROOM
                        Button(action: {self.showAlertLeave.toggle()}) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor((Color(UIColor.systemGray5)))
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("Leave Room")
                                        .foregroundColor(.red)
                                )
                        }
                        .alert(isPresented: $showAlertLeave) {
                            Alert(title:
                                    Text("You won't be a member of this room anymore"
                                    ),
                                  primaryButton: .default(Text("Leave")){
                                    sai_sala()
                                  },
                                  secondaryButton: .cancel())
                        }
                        
                        //MARK: - LOGOUT
                        Button(action: {self.showAlertLogOut.toggle()}) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("Log out")
                                        .foregroundColor(.white)
                                )
                        }
                        .alert(isPresented: $showAlertLogOut) {
                            Alert(title: Text("Are you sure you want to log out?"),
                                  primaryButton: .default(Text("Log out")) {
                                    self.enterMode = .logOut
                                    UserDefaults.standard.set(
                                        enterMode.rawValue,
                                        forKey: "LastEnterMode"
                                    )
                                  },
                                  secondaryButton: .cancel())
                        }
                        
                        // Pra espaçar um pouco o ultimo botao da TabBar
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(Color("whiteBlack"))
                            .frame(height: btn_height/4)
                            .frame(width: btn_width)
                    }
                }
                .padding(.top, -645)
            }
            .navigationBarItems(
                leading:
                    Button(action: {self.showRooms.toggle()}) {
                        Image(systemName: "rectangle.grid.1x2")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showRooms) {
                        RoomsView(usuario: self.membro.usuario)
                            .environmentObject(self.dao)
                    },
                trailing: Button(action: {self.showEditProfile.toggle()}) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
//                .sheet(isPresented: $showEditProfile) {
//                    EditProfileView(usuario: self.membro.usuario)
//                })
                .sheet(
                    isPresented: $showEditProfile,
                    onDismiss: {
                        self.nome = self.membro.usuario.nome
                        self.foto = self.membro.usuario.foto_perfil
                        self.fluencia = self.membro.usuario.fluencia_ingles
                    }
                ){
                    EditProfileView(usuario: self.membro.usuario)
                        .environmentObject(dao)
                })
            .onAppear {
                self.nome = self.membro.usuario.nome
                self.foto = self.membro.usuario.foto_perfil
                self.fluencia = self.membro.usuario.fluencia_ingles
            }
        }
    } //body
    
    func sai_sala(){
        sala.removeMembro(membro: self.membro.id)
        
        if sala.membros.isEmpty {
            // Sala morre se nao tem ninguem
            apagaSalaFromCloud(sala: sala)
        } else if sala.membros.count == 1 {
            // Unico membro da sala deve ser admin
            unicoMembroIsAdmin(sala: sala)
        } else {
            self.proxima_sala()
        }
        
        CKManager.deleteRecordCompletion(recordName: self.membro.id) { (result) in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func apagaSalaFromCloud(sala: Sala){
        dao.removeSala(sala)
        
        CKManager.deleteRecordCompletion(recordName: sala.id) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        for membro in sala.membros {
                            CKManager.deleteRecord(recordName: membro.id)
                        }
                        for categ in sala.categorias {
                            CKManager.deleteRecord(recordName: categ.id)
                        }
                        for post in sala.posts {
                            sala.excluiPost3(post: post)
                        }
                        self.proxima_sala()
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func unicoMembroIsAdmin(sala: Sala) {
        sala.membros[0].isAdmin = true
        self.proxima_sala()
        CKManager.modifyMembro(membro: sala.membros[0])
    }
    
    func proxima_sala(){
        let usuario = membro.usuario
        let salas = dao.getSalasByUser(id: membro.usuario.id)
        if salas.isEmpty {
            usuario.sala_atual = nil
        } else {
            usuario.sala_atual = salas[0].id
        }
        dao.idSalaAtual = usuario.sala_atual
        CKManager.modifyUsuario(user: usuario)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(enterMode: .constant(.logOut))
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}
