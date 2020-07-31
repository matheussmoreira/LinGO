//
//  ProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    var sala: Sala
    var id_membro: Int
    var membro: Membro { return sala.getMembro(id: id_membro)! }
    
    var body: some View {
        //Text("Profile View!")
            //.fontWeight(.bold)
        VStack {
            Image(membro.foto_perfil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150.0, height: 150.0)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 5)
            )
            Text(membro.nome)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.gray)
            Text(sala.nome)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
    } //body
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(sala: DAO().salas[0], id_membro: 1)
    }
}
