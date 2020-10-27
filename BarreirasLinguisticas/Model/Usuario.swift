//
//  Usuario.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKitMagicCRUD

enum Fluencia: String {
    case advanced = "Advanced English"
    case intermed = "Intermediate English"
    case basic = "Basic English"
    case unknown = "Unknown English"
}

class Usuario: Equatable, Identifiable, ObservableObject/*, CKMRecord*/ {
    //var recordName: String?
    let id: Int
    var email: String
    var senha: String
    @Published var nome: String
    @Published var foto_perfil: Image
    @Published var pais: String
    @Published var fluencia_ingles: Fluencia
    var cor_fluencia: Color {
        switch fluencia_ingles {
        case .advanced: return .blue
        case .intermed: return .yellow
        case .basic: return .green
        default: return .black
        }
    }
    
    init(id: Int, email: String?, senha: String?, nome: String?, foto_perfil: Image?, pais: String?, fluencia_ingles: Fluencia?) {
        self.id = id
        self.email = email ?? "<membro@email.com>"
        self.senha = senha ?? "<senha>"
        self.nome = nome ?? "<nome>"
        self.foto_perfil = foto_perfil ?? Image("perfil")
        self.pais = pais ?? "<pais>"
        self.fluencia_ingles = fluencia_ingles ?? Fluencia.unknown
    }
    
    static func == (lhs: Usuario, rhs: Usuario) -> Bool {
        return lhs.id == rhs.id
    }
}
