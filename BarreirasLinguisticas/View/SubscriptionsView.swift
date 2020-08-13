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
                    VStack {
                        ForEach(self.assinaturas.sorted(by: {$0.nome < $1.nome})) { asst in
                            NavigationLink(destination: PostsCategorieView(categoria: asst, sala: self.sala).environmentObject(self.membro)) {
                                RoundedRectangle(cornerRadius: 45)
                                    .fill(LingoColors.lingoBlue)
                                    .frame(height: 50)
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
            .navigationBarTitle("Your subscriptions")
            .navigationBarItems(trailing:
                HStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
            })
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
