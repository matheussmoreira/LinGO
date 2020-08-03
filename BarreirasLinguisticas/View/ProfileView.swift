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
        //Text("Profile View!")
            //.fontWeight(.bold)
        VStack {
            Image(membro.usuario.foto_perfil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150.0, height: 150.0)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 5)
            )
            Text(membro.usuario.nome)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.gray)
            Text(sala.nome)
                .font(.subheadline)
                .foregroundColor(Color.gray)
            Text("Members in this room")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.top)
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(sala.membros) { membro in
                        Text(membro.usuario.nome)
                            .padding(.leading)
                    }
                }
            }
        }
    } //body
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sala: DAO().salas[0], membro: DAO().salas[0].membros[0])
    }
}
