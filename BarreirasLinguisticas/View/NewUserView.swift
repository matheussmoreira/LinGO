//
//  NewUserView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 26/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct NewUserView: View {
    @EnvironmentObject var dao: DAO
    @State private var nome: String = ""
    @State private var fluenciaSelecionada = 0
    @Binding var loggedIn: Bool
    let fluencias = ["Basic","Intermediate", "Advanced"]
    
    
    var body: some View {
        Text("Create your profile")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .font(.title)
        
        
        Form {
            Section {
                Text("Your Name")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                TextField("", text: $nome)
            }
            
            Section {
                Text("Your fluency")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                List(0..<fluencias.count){ idx in
                    Text(fluencias[idx])
                        .onTapGesture {
                            fluenciaSelecionada = idx
                        }
                        .foregroundColor(fluencias[idx] == fluencias[fluenciaSelecionada] ? .blue : .black)
                }
            }
        }
        
        Button(action: {
            let novoUsuario = Usuario(id: UUID().hashValue, email: nil, senha: nil, nome: nome, foto_perfil: nil, pais: nil, fluencia_ingles: pegaFluenciaEnum())
            dao.addNovoUsuario(novoUsuario)
            dao.usuario_atual = novoUsuario
            loggedIn = true
        }) {
            Text("Create")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .background(Color.white)
                .cornerRadius(5)
        }
        
    }
    
    func pegaFluenciaEnum() -> fluencia {
        switch fluenciaSelecionada {
            case 0:
                return fluencia.basic
            case 1:
                return fluencia.intermed
            case 2:
                return fluencia.advanced
            default:
                return fluencia.unknown
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(loggedIn: .constant(false))
    }
}
