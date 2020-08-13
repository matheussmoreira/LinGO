//
//  RoomMembersView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomMembersView: View {
    @ObservedObject var membro: Membro
    @ObservedObject var sala: Sala
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ForEach(sala.membros.sorted(by: { $0.usuario.nome < $1.usuario.nome })) { membro in
                    RoundedRectangle(cornerRadius: 45)
                        .fill(LingoColors.lingoBlue)
                        .frame(width: UIScreen.width*0.85, height: 40)
                        .overlay(
                            HStack{
                                Image(membro.usuario.foto_perfil)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30.0, height: 30.0)
                                    .clipShape(Circle())
                                    .padding(.leading)
                                
                                Text(membro.usuario.nome)
                                    .padding(.leading)
                                    .foregroundColor(.white)
                                Spacer()
                                if membro.is_admin {
                                    Text("admin")
                                        .foregroundColor(.white)
                                        .padding(.trailing,20)
                                }
                                
                            }
                    ) //overlay
                } //ForEach
            } //VStack
        } //ScrollView
            .navigationBarTitle("Members of this room")
            .navigationBarItems(trailing:
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
            })
    } //body
}

struct RoomMembersView_Previews: PreviewProvider {
    static var previews: some View {
        RoomMembersView(membro: DAO().salas[0].membros[0], sala: DAO().salas[0])
    }
}
