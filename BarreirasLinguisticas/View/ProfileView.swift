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
    @State private var showRooms = false
    @State private var showAlertLeave = false
    @State private var showAlertLogOut = false
    @State private var showEditProfile = false
    @State private var showAdminSheet = false
    @Binding var loggedIn: Bool
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .padding(.bottom, -100.0)
                    .padding(.top, -1050)
                    .frame(width: 600.0, height: 600.0)
                    .foregroundColor(LingoColors.lingoBlue)
                
                //MARK: - DADOS DO MEMBRO
                VStack {
                    membro.usuario.foto_perfil
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150.0, height: 150.0)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.primary, lineWidth: 8)
                                .colorInvert()
                    )
                    
                    Text(membro.usuario.nome)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                    
                    HStack {
                        Text(membro.usuario.fluencia_ingles.rawValue)
                            .foregroundColor(Color.gray)
                        Circle()
                            .fill(membro.usuario.cor_fluencia)
                            .frame(width: 15.0, height: 15.0)
                    }
                    
                    Text(sala.nome)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    
                    //MARK: - POSTS PUBLICADOS
                    ScrollView(.vertical, showsIndicators: false) {
                        NavigationLink(destination:
                        MyPublications().environmentObject(membro)) {
                            RoundedRectangle(cornerRadius: corner)
                                .foregroundColor(lingoBlue)
                                .frame(height: btn_height)
                                .frame(width: btn_width)
                                .overlay(
                                    Text("My publications")
                                        .foregroundColor(.white)
                            )
                        }
                        
                        //MARK: - POSTAS SALVOS
                        NavigationLink(destination:
                        MySavedPosts().environmentObject(membro)) {
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
                        NavigationLink(destination: SubscriptionsView(sala: sala).environmentObject(membro)) {
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
                        NavigationLink(destination:
                        RoomMembersView(membro: membro, sala: sala)) {
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
                        if(membro.is_admin) {
                            Button(action: {self.showAdminSheet.toggle()}){
                                RoundedRectangle(cornerRadius: corner)
                                    .foregroundColor(lingoBlue)
                                    .frame(height: btn_height)
                                    .frame(width: btn_width)
                                    .overlay(
                                        Text("Admin")
                                            .foregroundColor(.white)
                                )
                            }.sheet(isPresented: $showAdminSheet) {
                                AdminView()
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
                        }.alert(isPresented: $showAlertLeave) {
                            Alert(title: Text("Are you sure you want to leave this room?"),
                                  primaryButton: .default(Text("Leave")){
                                    self.sala.removeMembro(membro: self.membro.usuario.id)
                                    self.proxima_sala()
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
                        }.alert(isPresented: $showAlertLogOut) {
                            Alert(title: Text("Are you sure you want to log out?"),
                                  primaryButton: .default(Text("Log out")) {
                                    self.loggedIn.toggle()
                                },
                                  secondaryButton: .cancel())
                        }
                    } //ScrollView
                } //VStack
                    .padding(.top, -575)
            } //VStack
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
                    .sheet(isPresented: $showEditProfile) {
                        EditProfileView(usuario: self.membro.usuario)
                })
        } //NavigationView
    } //body
    
    func proxima_sala(){
        let salas = dao.getSalasByUser(id: membro.usuario.id)
        if salas.isEmpty {
            dao.sala_atual = nil
        }
        else {
            dao.sala_atual = salas[0]
        }
        if sala.membros.isEmpty {
            dao.removeSala(sala: sala)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(loggedIn: .constant(true)).environmentObject(DAO().salas[0].membros[0])
    }
}

struct AdminView: View {
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        
        VStack{
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
                .padding(.top,10)
            
            NavigationView{
                //Spacer()
                NavigationLink(destination: PostsDenunciados()) {
                    RoundedRectangle(cornerRadius: corner)
                        .foregroundColor(lingoBlue)
                        .frame(height: btn_height)
                        .frame(width: btn_width)
                        .overlay(
                            Text("Posts denunciados")
                                .foregroundColor(.white)
                    )
                }
                
                NavigationLink(destination: ComentariosDenunciados()) {
                    RoundedRectangle(cornerRadius: corner)
                        .foregroundColor(lingoBlue)
                        .frame(height: btn_height)
                        .frame(width: btn_width)
                        .overlay(
                            Text("Comentários denunciados")
                                .foregroundColor(.white)
                    )
                }
                
                Button(action: {}){
                    RoundedRectangle(cornerRadius: corner)
                        .foregroundColor(lingoBlue)
                        .frame(height: btn_height)
                        .frame(width: btn_width)
                        .overlay(
                            Text("Convidar novo membro")
                                .foregroundColor(.white)
                    )
                }
                //Spacer()
            } //NavigationView
        } //VStack
    } //body
}

struct PostsDenunciados: View {
    var body: some View {
        Text("Posts denunciados")
    }
}

struct ComentariosDenunciados: View {
    var body: some View {
        Text("Comentários denunciados")
    }
}
