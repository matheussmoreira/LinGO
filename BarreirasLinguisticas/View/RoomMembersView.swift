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
    @State private var showMembro: [String:Bool] = [:]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                ForEach(sala.membros.sorted(
                            by: { $0.usuario.nome < $1.usuario.nome })
                ) { membro_sala in
                    MemberButton(
                        sala: self.sala,
                        membro: self.membro,
                        membro_sala: membro_sala
                    )
                } //ForEach
            } //VStack
        } //ScrollView
        .navigationBarTitle(sala.nome)
        .navigationBarItems(trailing:
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .imageScale(.large)
                                        .foregroundColor(LingoColors.lingoBlue)
                                })
    } //body
}

struct RoomMembersView_Previews: PreviewProvider {
    static var previews: some View {
        RoomMembersView(membro: dao.salas[0].membros[0], sala: dao.salas[0])
    }
}

struct MemberButton: View {
    @ObservedObject var sala: Sala
    @ObservedObject var membro: Membro
    @State private var showMembro = false
    var membro_sala: Membro
    
    var body: some View {
        Button(action: {
            if (self.membro.usuario.id != self.membro_sala.usuario.id) && self.membro.is_admin {
                self.showMembro.toggle()
            }
        }) {
            RoundedRectangle(cornerRadius: 45)
                .fill(LingoColors.lingoBlue)
                .frame(width: UIScreen.width*0.95, height: 50)
                .overlay(
                    HStack{
                        Image(uiImage: membro_sala.usuario.foto_perfil)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30.0, height: 30.0)
                            .clipShape(Circle())
                            .padding(.leading)
                        
                        Text(membro_sala.usuario.nome)
                            .padding(.leading)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        if membro_sala.is_admin {
                            ZStack {
                                Capsule()
                                    .frame(width: 65.0, height: 30.0)
                                    .padding(.trailing,20)
                                    .foregroundColor(Color.green)
                                Text("admin")
                                    .foregroundColor(.white)
                                    .padding(.trailing,20)
                            }
                        }
                    }
                ) //overlay
        }//Button
        .actionSheet(isPresented: self.$showMembro) {
            ActionSheet(
                title: Text(membro_sala.usuario.nome),
                message: Text(self.sala.nome),
                buttons: [
                    .default(
                        membro_sala.is_admin ?
                            Text("Dismiss as admin") :
                            Text("Turn admin")
                    ){
                        self.membro_sala.updateAdminStatus()
                    },
                    .default(Text("Remove from room")){
                        self.removeDaSala(sala: sala, membro_sala: membro_sala)
                    },
                    .cancel()
                ])
        } //actionSheet
    } //body
    
    func removeDaSala(sala: Sala, membro_sala: Membro){
        sala.removeMembro(membro: self.membro_sala.id)
        CKManager.deleteRecord(recordName: self.membro_sala.id) { (result) in
            switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
}
