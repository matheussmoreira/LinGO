//
//  RoomMembersView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomMembersView: View {
    @State var membros: [Membro]
    
    var body: some View {
        VStack {
            Text("Members in this room")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(membros) { membro in
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
        RoomMembersView(membros: DAO().salas[0].membros)
    }
}
