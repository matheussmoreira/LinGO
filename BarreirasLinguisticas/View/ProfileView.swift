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
                    Image(uiImage: membro.usuario.foto_perfil )
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
                        Text(membro.usuario.fluencia_ingles)
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
                                    .environmentObject(self.membro)
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
                .sheet(isPresented: $showEditProfile) {
                    EditProfileView(usuario: self.membro.usuario)
                })
        }
    } //body
    
    func sai_sala(){
        sala.removeMembro(membro: self.membro.id)
        CKManager.deleteRecord(recordName: self.membro.id) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        if sala.membros.isEmpty {
                            apagaSalaFromCloud(sala: sala)
                        } else if sala.membros.count == 1 {
                            unicoMembroIsAdmin(sala: sala)
                        }
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func unicoMembroIsAdmin(sala: Sala) {
        sala.membros[0].is_admin = true
        CKManager.modifyMembro(membro: sala.membros[0]) { (result) in
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
        CKManager.deleteRecord(recordName: sala.id) { (result) in
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.proxima_sala()
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func proxima_sala(){
        let usuario = membro.usuario
        let salas = dao.getSalasByUser(id: membro.usuario.id)
        if salas.isEmpty { usuario.sala_atual = nil }
            else { usuario.sala_atual = salas[0].id }
        
        CKManager.modifyUsuario(user: usuario) { (result) in
            switch result {
                case .success(let modifiedUser):
                    DispatchQueue.main.async {
                        dao.sala_atual = modifiedUser.sala_atual
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
        
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(enterMode: .constant(.logOut))
//            .environmentObject(DAO().salas[0].membros[0])
//    }
//}

struct AdminView: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        
        VStack{
            NavigationView {
                VStack {
                    Rectangle()
                        .frame(width: 60, height: 6)
                        .cornerRadius(3.0)
                        .opacity(0.1)
                        .padding(.top)
                    Spacer()
                    Text("What do you want to do?")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    NavigationLink(destination:
                                    PostsDenunciados()
                                    .environmentObject(sala)
                                    .environmentObject(membro)
                    ) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported posts")
                                    .foregroundColor(.white)
                            )
                    }
                    
//                    Button(action: {}) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(.gray)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported comments")
                                    .foregroundColor(.white)
                            )
//                    }
                    
//                    Button(action: {}){
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(.gray)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Invite a new member")
                                    .foregroundColor(.white)
                            )
//                    }
                    
                    Spacer()
                }.navigationBarHidden(true)
            }
        }
    }
}

struct PostsDenunciados: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State var posts: [Post] = []
    
    var body: some View {
        VStack{
            if posts.isEmpty{
                Text("No reported posts 🙂")
                    .foregroundColor(.gray)
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(posts) { post in
                        NavigationLink(
                            destination: PostView(sala: sala, post: post)
                        ){
                            PostCardView(post: post, sala: sala, width: 0.85)
                                .environmentObject(membro)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(
            Text("Reported Posts")
        )
        .onAppear {
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
