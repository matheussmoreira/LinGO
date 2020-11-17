//
//  SubscriptionsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct SubscriptionsView: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var sala: Sala
    @State private var assinaturas: [Categoria] = []
    
    var body: some View {
        VStack {
            if (self.assinaturas.isEmpty) {
                VStack {
                    Spacer()
                    Text("You have no subscriptions 😕")
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(self.assinaturas.sorted(by: { $0.nome < $1.nome })) { asst in
                            NavigationLink(
                                destination: PostsOfCategorieView(categoria: asst, sala: self.sala)
                                    .environmentObject(self.membro)
                            ){
                                RoundedRectangle(cornerRadius: 45)
                                    .fill(LingoColors.lingoBlue)
                                    .frame(height: 50)
                                    .frame(width: UIScreen.width*0.95)
                                    .overlay(
                                        Text(asst.nome)
                                            .padding(.leading)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Your subscriptions")
//        .navigationBarItems(trailing:
//                                HStack {
//                                    Image(systemName: "magnifyingglass")
//                                        .foregroundColor(LingoColors.lingoBlue)
//                                        .imageScale(.large)
//                                })
        .onAppear {
            self.assinaturas = sala.getCategorias(ids: self.membro.assinaturas)
        }
    } //body
    
}

//struct SubscriptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionsView(sala: dao.salas[0])
//            .environmentObject(dao.salas[0].membros[0])
//    }
//}
