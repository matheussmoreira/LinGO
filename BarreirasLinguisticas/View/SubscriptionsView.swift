//
//  SubscriptionsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct SubscriptionsView: View {
    @ObservedObject var sala: Sala
    @EnvironmentObject var membro: Membro
    
    var body: some View {
        VStack {
            Text("Your subscriptions")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            
            if (membro.assinaturas.count == 0) {
                VStack {
                    Spacer()
                    Text("You have no subscriptions :(")
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        ForEach(membro.assinaturas) { asst in
                            NavigationLink(destination: PostsCategorieView(categoria: asst, sala: self.sala).environmentObject(self.membro)) {
                                RoundedRectangle(cornerRadius: 45)
                                    .fill(Color(red: 0/255, green: 162/255, blue: 255/255))
                                    .frame(height: 40)
                                    .frame(width: UIScreen.width*0.85)
                                    .overlay(
                                        Text(asst.nome)
                                            .padding(.leading)
                                            .foregroundColor(.white)
                                    )
                            }
                        } //ForEach
                    } //VStack
                } //ScrollView
            } //else
        }//VStack
    } //body
    
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView(sala: DAO().salas[0])
            .environmentObject(DAO().salas[0].membros[0])
    }
}
