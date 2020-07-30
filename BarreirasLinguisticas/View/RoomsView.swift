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
            if dao.salas.count == 0 {
                Spacer()
                Text("There are no rooms :(")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            else{
                NavigationView {
                    VStack{
                        ForEach(dao.salas) { sala in
                            NavigationLink(destination: ContentView(sala: sala)){
                                Text("Go to \(sala.nome)")
                                    .fontWeight(.bold)
                            }
                        }
                    } //VStack
                } //NavigationView
            } //else
            Button(action: {self.dao.addNovaSala()}) {
                Text("Add new Room")
            }
        } //VStack
    } //body
    
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsView().environmentObject(DAO())
    }
}
