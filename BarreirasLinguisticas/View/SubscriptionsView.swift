//
//  SubscriptionsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 06/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct SubscriptionsView: View {
    var assinaturas: [Categoria]
    
    var body: some View {
        VStack {
            Text("Your subscriptions")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(assinaturas) { categ in
                        RoundedRectangle(cornerRadius: 45)
                            .fill(Color.blue)
                        .frame(height: 40)
                            .frame(width: UIScreen.width*0.85)
                        .overlay(
                            Text(categ.nome)
                                .padding(.leading)
                                .foregroundColor(.white)
                            //Spacer()
                        )
                    } //ForEach
                } //VStack
            } //ScrollView
        } //VStack
    }
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView(assinaturas: DAO().salas[0].membros[0].assinaturas)
    }
}
