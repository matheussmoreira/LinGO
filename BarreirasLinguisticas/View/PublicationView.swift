//
//  PublicationView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PublicationView: View {
    var sala: Sala
    var id_membro: Int
    var membro: Membro { return sala.getMembro(id: id_membro)! }
    
    var body: some View {
        Text("Publication View!")
            .fontWeight(.bold)
    } //body
}

struct PublicationView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationView(sala: DAO().salas[0], id_membro: 1)
    }
}
