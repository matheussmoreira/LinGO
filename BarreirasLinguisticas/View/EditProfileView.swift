//
//  EditProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 20/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var dao: DAO
    @EnvironmentObject var membro: Membro
    @EnvironmentObject var sala: Sala
    
    var body: some View {
        NavigationView {
            VStack {
                Image(membro.usuario.foto_perfil)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.primary, lineWidth: 8)
                            .colorInvert()
                            .shadow(radius: 8))
                    .padding(.all, 32)
                
                Form {
                    Section {
                        TextField("Your name here", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        
                        Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("English Level")) {
                            Text("Beginner").tag(1)
                            Text("Intermediate").tag(2)
                            Text("Advanced").tag(3)
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(leading: Text("Cancel"), trailing:  Text("Save"))
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
