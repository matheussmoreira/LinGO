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
    @State var assinaturas: [Categoria] = []
    
    var body: some View {
        VStack {
            Text("Your subscriptions")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            
            if (self.assinaturas.count == 0) {
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
                        ForEach(self.assinaturas) { asst in
                            NavigationLink(destination: PostsCategorieView(categoria: asst, sala: self.sala).environmentObject(self.membro)) {
                                RoundedRectangle(cornerRadius: 45)
                                    .fill(LingoColors.lingoBlue)
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
            .onAppear {
                self.assinaturas = self.membro.assinaturas
            }
    } //body
    
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView(sala: DAO().salas[0])
            .environmentObject(DAO().salas[0].membros[0])
    }
}
