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
    @Binding var loggedIn: Bool
    @State private var showRooms = false
    @State private var showAlertLeave = false
    @State private var showAlertLogOut = false
    @State private var showEditProfile = false
    @State private var showAdminSheet = false
    
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
                    membro.usuario.foto_perfil
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150.0, height: 150.0)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 8)
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
                            }
                            .sheet(isPresented: $showAdminSheet) {
                                AdminView()
                                    .environmentObject(self.sala)
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
                                    self.sala.removeMembro(
                                        membro: self.membro.usuario.id
                                    )
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
                        }
                        .alert(isPresented: $showAlertLogOut) {
                            Alert(title: Text("Are you sure you want to log out?"),
                                  primaryButton: .default(Text("Log out")) {
                                    self.loggedIn.toggle()
                                  },
                                  secondaryButton: .cancel())
                        }
                    } //ScrollView
                } //VStack
                .padding(.top, -645)
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
    @EnvironmentObject var sala: Sala
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        
        VStack{
            //            Rectangle()
            //                .frame(width: 60, height: 6)
            //                .cornerRadius(3.0)
            //                .opacity(0.1)
            //                .padding(.top,10)
            //
            NavigationView{
                
                VStack {
                    Text("What do you want to do?")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    NavigationLink(destination: PostsDenunciados().environmentObject(sala)) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported posts")
                                    .foregroundColor(.white)
                            )
                    }
                    
                    NavigationLink(destination: ComentariosDenunciados()) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported comments")
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Button(action: {}){
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Invite a new member")
                                    .foregroundColor(.white)
                            )
                    }
                    //Spacer()
                } //VStack
            } //NavigationView
        } //VStack
    } //body
}

struct PostsDenunciados: View {
    @EnvironmentObject var sala: Sala
    @State var posts: [Post] = []
    
    var body: some View {
        VStack{
            if posts.isEmpty{
                Text("No reported posts :)")
                    .foregroundColor(.gray)
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(posts) { post in
                        PostCardView(post: post, width: 0.85)
                    }
                }
            }
        }
        .navigationBarTitle(
            Text("Reported Posts")
            //                .font(.system(.title, design: .rounded)),displayMode: .inline
        )
        .onAppear {
            //            print("Contando os posts denunciados")
            self.posts = self.sala.posts.filter{!$0.denuncias.isEmpty}
        }
    }//body
}

struct ComentariosDenunciados: View {
    var body: some View {
        VStack {
            Text("Reported Comments will be here")
                .foregroundColor(.gray)
        }.navigationBarTitle(
            Text("Reported Comments")
        )
    }
}
