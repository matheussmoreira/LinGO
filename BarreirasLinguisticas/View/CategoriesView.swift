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
    @State var texto: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                TextField("Search for categories or posts ???", text: $texto)
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    .padding()
                    .animation(.default)
                
                List (dao.categorias){ item in
                    HStack {
                        Image(systemName: "command")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .semibold))
                        
                        VStack(alignment: .leading) {
                            Text(item.nome)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                            Text("Related Tags")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .navigationBarTitle(Text("Categories"))
            }
        }
        
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
