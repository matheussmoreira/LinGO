//
//  HomeView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        //Text("Home View!")
        VStack {
            if dao.getPost(id: 1)?.link?.metadata != nil {
                Image(uiImage: dao.getPost(id: 1)?.link_image)
                    .aspectRatio(contentMode: .fit)
                //LinkView(metadata: dao.getPost(id: 1)?.link?.metadata)
                    //.aspectRatio(contentMode: .fit)
            }
            else {
                Text("Não pegou os metadados")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
