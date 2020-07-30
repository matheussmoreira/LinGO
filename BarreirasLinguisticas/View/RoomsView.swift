//
//  RoomsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomsView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        VStack{
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(dao.salas) { sala in
                        NavigationLink(destination: ContentView(sala: sala)){
                            Text("Go to \(sala.nome)")
                                .fontWeight(.bold)
                        }
                    }
                } //ScrollView
            } //NavigationView
        } //VStack
    } //body
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView().environmentObject(DAO())
    }
}
