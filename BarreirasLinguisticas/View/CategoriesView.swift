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
    
    var body: some View {
        Text("Categories View!")
    } // body
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
