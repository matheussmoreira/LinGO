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
    
    var body: some View {
        //Text("Categories View!")
        VStack {
            Text(dao.getPost(id: 1)?.link?.metadata?.title ?? "No title")
            
            if dao.getPost(id: 1)?.link?.metadata != nil {
                LinkView(metadata: dao.getPost(id: 1)?.link?.metadata).aspectRatio(contentMode: .fit)
            } else {
                Text("Link preview aqui")
                    .font(.title)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.init(white: 0.4))
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
