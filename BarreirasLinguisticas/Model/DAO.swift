//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class DAO: ObservableObject {
    static var unicaInstancia = DAO()
    var salas: [Sala] = []
    
    init(){
        self.salas.append(Sala(id: 0, nome: "Room 0"))
        self.salas.append(Sala(id: 1, nome: "Room 1"))
        self.salas.append(Sala(id: 2, nome: "Room 2"))
    }
    
    func getSala(id: Int) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
}
