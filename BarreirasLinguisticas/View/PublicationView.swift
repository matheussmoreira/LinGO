//
//  PublicationView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PublicationView: View {
    @EnvironmentObject var dao: DAO
    
    // Interface generica montada para testar a leitura dos dados
    var body: some View {
        Text("Publication View!")
    }
}

struct PublicationView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationView()
    }
}
