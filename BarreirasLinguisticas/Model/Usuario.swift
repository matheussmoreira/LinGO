//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI

enum fluencia: String {
    case advanced = "Advanced English"
    case intermed = "Intermediate English"
    case basic = "Basic English"
    case unknown = "<fluencia>"
}

class Usuario: Equatable, Identifiable, ObservableObject {
    
    let id: Int
    var email: String
    var senha: String
    var nome: String
    var foto_perfil: String
    var pais: String
    var fluencia_ingles: fluencia
    var cor_fluencia: Color {
        switch fluencia_ingles {
        case .advanced: return .blue
        case .intermed: return .yellow
        case .basic: return .green
        default: return .black
        }
    }
    
    init(id: Int, email: String?, senha: String?, nome: String?, foto_perfil: String?, pais: String?, fluencia_ingles: fluencia?) {
        self.id = id
        self.email = email ?? "<membro@email.com>"
        self.senha = senha ?? "<senha>"
        self.nome = nome ?? "<nome>"
        self.foto_perfil = foto_perfil ?? "user_icon"
        self.pais = pais ?? "<pais>"
        self.fluencia_ingles = fluencia_ingles ?? fluencia.unknown
    }
    
    static func == (lhs: Usuario, rhs: Usuario) -> Bool {
        return lhs.id == rhs.id
    }
}
