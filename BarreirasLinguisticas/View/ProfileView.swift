//
//  ProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    //@EnvironmentObject var dao: DAO
    @ObservedObject var sala: Sala
    @ObservedObject var membro: Membro
    
    var body: some View {
        VStack {
            Image(membro.usuario.foto_perfil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150.0, height: 150.0)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 3)
                )
            Text(membro.usuario.nome)
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
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
            
            NavigationLink(destination:
            MyPublishedPosts(published: membro.posts_publicados)) {
                RoundedRectangle(cornerRadius: 45)
                .fill(Color.blue)
                .frame(height: 40)
                .frame(width: 200)
                .overlay(
                    Text("My published posts")
                        .foregroundColor(.white)
                )
            }
            
            NavigationLink(destination:
            MySavedPosts(saved: membro.posts_salvos)) {
                RoundedRectangle(cornerRadius: 45)
                .fill(Color.blue)
                .frame(height: 40)
                .frame(width: 200)
                .overlay(
                    Text("My saved posts")
                        .foregroundColor(.white)
                )
            }
            
            NavigationLink(destination:
            RoomMembersView(membros: sala.membros)) {
                RoundedRectangle(cornerRadius: 45)
                .fill(Color.blue)
                .frame(height: 40)
                .frame(width: 200)
                .overlay(
                    Text("Members in this room")
                        .foregroundColor(.white)
                )
            }
            
//            Divider()
//            Text("Members in this room")
//                .font(.subheadline)
//                .fontWeight(.bold)
//                .padding(.top)
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack{
//                    ForEach(sala.membros) { membro in
//                        Text(membro.usuario.nome)
//                            .padding(.leading)
//                    }
//                }
//            }
        } //VStack
    } //body
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sala: DAO().salas[0], membro: DAO().salas[0].membros[0])
    }
}
