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
    @State var showAddMembers = false
    //@State var membros: [Membro]
    
    var body: some View {
        VStack {
            Text("Members in this room")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            
            if (membro.is_admin) {
                Button(action: { self.showAddMembers.toggle() }){
                    RoundedRectangle(cornerRadius: 45)
                        .fill(Color.green)
                        .frame(height: 40)
                        .frame(width: UIScreen.width*0.85)
                    .overlay(
                        HStack{
                             Image(systemName: "plus.app")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30.0, height: 30.0)
                                .padding(.leading)
                                .foregroundColor(.white)
                                
                            Text("Add new members")
                                .padding(.leading)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    )
                }
                .sheet(isPresented: $showAddMembers) {
                    VStack {
                        Spacer()
                        Text("Members to be added will appear here")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            } //if is_admin
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(sala.membros.sorted(by: { $0.usuario.nome < $1.usuario.nome })) { membro in
                        RoundedRectangle(cornerRadius: 45)
                            .fill(Color.blue)
                        .frame(height: 40)
                            .frame(width: UIScreen.width*0.85)
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
                        )
                    } //ForEach
                } //VStack
            } //ScrollView
        } //VStack
    } //body
}

struct RoomMembersView_Previews: PreviewProvider {
    static var previews: some View {
        RoomMembersView(membro: DAO().salas[0].membros[0], sala: DAO().salas[0])
    }
}
