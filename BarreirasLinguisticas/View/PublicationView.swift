//
//  PublicationView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct PublicationView: View {
    @ObservedObject var sala: Sala
    @ObservedObject var membro: Membro
    
    var body: some View {
//        Text("Publication View!")
//            .fontWeight(.bold)
        PostEditorView()
    } //body
}

struct PublicationView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationView(sala: DAO().salas[0], membro: DAO().salas[0].membros[0])
    }
}
