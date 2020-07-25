//
//  CategoriesView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @State private var dao = DAO.unicaInstancia
    
    // Interface generica montada para testar a leitura dos dados
    
    var body: some View {
        //Text("Categories View!")
        VStack {
            Text(dao.getPost(id: 1)?.link?.metadata?.title ?? "Não pegou o título")
            
            if dao.getPost(id: 1)?.link?.metadata != nil {
                LinkView(metadata: dao.getPost(id: 1)?.link?.metadata).aspectRatio(contentMode: .fit)
            } else {
                Text("Se você está vendo isso é porque a recuperação dos metadados do link de um post não está funcionando :(")
                    .font(.title)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init(white: 0.4))
                    .padding(.all)
            }
            
        }
        /*List(dao.posts) { item in
            Text(item.nome)
        }*/
    }
    
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView().environmentObject(DAO())
    }
}
