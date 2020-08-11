//
//  ProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var sala: Sala
    @EnvironmentObject var membro: Membro
    let btn_height: CGFloat = 40
    let btn_width: CGFloat = 200
    let corner: CGFloat = 45
    
    var body: some View {
        VStack {
            Circle()
                .padding(.bottom, -100.0)
                .padding(.top, -1000)
                .frame(width: 600.0, height: 600.0)
                .foregroundColor(LingoColors.lingoBlue)
            
            //MARK: - DADOS DO MEMBRO
            VStack {
                Image(membro.usuario.foto_perfil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 8)
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
                NavigationLink(destination:
                MyPublishedPosts().environmentObject(membro)) {
                    RoundedRectangle(cornerRadius: corner)
                        .foregroundColor(Color(red: 0/255, green: 162/255, blue: 255/255))
                        .frame(height: btn_height)
                        .frame(width: btn_width)
                        .overlay(
                            Text("My published posts")
                                .foregroundColor(.white)
                    )
                }
                
                //MARK: - POSTAS SALVOS
                NavigationLink(destination:
                MySavedPosts().environmentObject(membro)) {
                    RoundedRectangle(cornerRadius: corner)
                        .foregroundColor(Color(red: 0/255, green: 162/255, blue: 255/255))
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
                        .foregroundColor(Color(red: 0/255, green: 162/255, blue: 255/255))
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
                        .foregroundColor(Color(red: 0/255, green: 162/255, blue: 255/255))
                        .frame(height: btn_height)
                        .frame(width: btn_width)
                        .overlay(
                            Text("Members in this room")
                                .foregroundColor(.white)
                    )
                }
                
                //MARK: - LEAVE
                RoundedRectangle(cornerRadius: corner)
                    .foregroundColor((Color(UIColor.systemGray5)))
                    .frame(height: btn_height)
                    .frame(width: btn_width)
                    .overlay(
                        Text("Leave")
                            .foregroundColor(.red)
                )
            } //VStack
                .padding(.top, -550)
        } //VStack
    } //body
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sala: DAO().salas[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
