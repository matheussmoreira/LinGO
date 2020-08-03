//
//  UsersView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        VStack{
            if dao.usuarios.count == 0 {
                Spacer()
                Text("There are no users yet :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else{
                NavigationView {
                    VStack{
                        Text("Choose a User")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        ForEach(dao.usuarios) { usuario in
                            NavigationLink(destination: RoomsView().environmentObject(self.dao)){
                                Text(usuario.nome)
                            }
                        }
                        Spacer()
                    } //VStack
                }//NavigationView
            } //else
        } //VStack
    } //body
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView().environmentObject(DAO())
    }
}
