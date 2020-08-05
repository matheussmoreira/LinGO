//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI

class Usuario: Identifiable, ObservableObject {
    let id: Int // = UUID()
    var email: String
    var senha: String
    var nome: String
    var foto_perfil: String
    var pais: String
    var fluencia_ingles: String
    var cor_fluencia: Color {
        switch fluencia_ingles {
        case "Advanced English": return .blue
        case "Intermediate English": return .yellow
        case "Basic English": return .green
        default: return .black
        }
    }
    
    init(id: Int, email: String?, senha: String?, nome: String?, foto_perfil: String?, pais: String?, fluencia_ingles: String?) {
        self.id = id
        self.email = email ?? "<membro@email.com>"
        self.senha = senha ?? "<senha>"
        self.nome = nome ?? "<nome>"
        self.foto_perfil = foto_perfil ?? "user_icon"
        self.pais = pais ?? "<pais>"
        self.fluencia_ingles = fluencia_ingles ?? "<fluencia>"
    }
}
