//
//  Voto.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 05/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class Voto {
    let membro: Membro
    let comentario: Comentario
    var votado: Bool
    
    init(membro: Membro, comentario: Comentario, votado: Bool) {
        self.membro = membro
        self.comentario = comentario
        self.votado = votado
    }
}
