//
//  CategoriesView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var dao: DAO
    
    // Interface generica montada para testar a leitura dos dados
    var body: some View {
        //Text("Categories View!")
        VStack {
            Text(dao.getPost(id: 1)?.link?.metadata?.title ?? "Não pegou o título")
            Text(verbatim: dao.getPost(id: 1)?.tags[0].nome ?? "Sem nome da tag")
            
            if dao.getPost(id: 1)?.link?.metadata != nil {
                LinkView(metadata: dao.getPost(id: 1)?.link?.metadata).aspectRatio(contentMode: .fit)
            } else {
                Text("Se você está vendo isso é porque a recuperação dos metadados do link não está funcionando :(")
                    .font(.title)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init(white: 0.4))
                    .padding(.all)
            }
        } // VStack
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
