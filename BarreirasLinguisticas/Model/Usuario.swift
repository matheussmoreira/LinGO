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

class Usuario: Equatable, Identifiable, ObservableObject, CKMRecord {
    var recordName: String?
    var id: String = ""//{self.recordName ?? String(self.hashValue)}
    @Published var nome: String = ""
    @Published var foto_perfil: Image = Image("perfil")
    @Published var sala_atual: Sala?
    @Published var fluencia_ingles: String = ""// = .unknown
    var cor_fluencia: Color {
        
        switch fluencia_ingles {
            case Fluencia.advanced.rawValue: return .blue
            case Fluencia.intermed.rawValue: return .yellow
            case Fluencia.basic.rawValue : return .green
            default: return .gray
        }
    }
    
    init(nome: String?, foto_perfil: Image?,fluencia_ingles: Fluencia?) {
        self.nome = nome ?? "<nome>"
        self.foto_perfil = foto_perfil ?? Image("perfil")
        self.fluencia_ingles = fluencia_ingles?.rawValue ?? Fluencia.unknown.rawValue
    }
    
    static func == (lhs: Usuario, rhs: Usuario) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func pegaFluencia(nome: String) -> Fluencia {
        switch nome {
            case "Basic English":
                return Fluencia.basic
            case "Intermediate English":
                return Fluencia.intermed
            case "Advanced English":
                return Fluencia.advanced
            default:
                return Fluencia.unknown
        }
    }
    
    static func pegaFluenciaNome(idx: Int) -> Fluencia {
        switch idx {
            case 0:
                return Fluencia.basic
            case 1:
                return Fluencia.intermed
            case 2:
                return Fluencia.advanced
            default:
                return Fluencia.unknown
        }
    }
    
    static func pegaFluenciaIdx(fluencia: Fluencia) -> Int {
        switch fluencia {
            case .basic:
                return 0
            case .intermed:
                return 1
            case .advanced:
                return 2
            default:
                return 0
        }
    }
    
    func encode(to encoder: Encoder) throws {
    }

    required init(from decoder: Decoder) throws {
        print("required init(from decoder:)")
//        fatalError("required init(from decoder:)")
    }
}
