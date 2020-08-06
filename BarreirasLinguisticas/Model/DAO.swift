//
//  DAO.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

class DAO: ObservableObject {
    //static var unicaInstancia = DAO()
    @Published var salas: [Sala] = []
    @Published var usuarios: [Usuario] = []
    
    init(){
        self.usuarios.append(Usuario(id: 1,
                                     email: "matheus@icloud.com",
                                     senha: "sucoDeAbacaxi",
                                     nome: "Matheus Moreira",
                                     foto_perfil: "foto_matheus",
                                     pais: "Brasil",
                                     fluencia_ingles: "Intermediate English"))
        
        self.usuarios.append(Usuario(id: 2,
                                     email: "victor@icloud.com",
                                     senha: "niteroiAmorzinho",
                                     nome: "Victor Duarte",
                                     foto_perfil: "foto_victor",
                                     pais: "Brasil",
                                     fluencia_ingles: "Advanced English"))
        
        self.usuarios.append(Usuario(id: 3,
                                     email: "evelyn@icloud.com",
                                     senha: "roxoComAmarelo",
                                     nome: "Evelyn de Jesus",
                                     foto_perfil: "foto_evelyn",
                                     pais: "Brasil",
                                     fluencia_ingles: "Basic English"))
        
        
        self.usuarios.append(Usuario(id: 4,
                                     email: "lidiane@icloud.com",
                                     senha: "chinaInBox",
                                     nome: "Lidiane Chen",
                                     foto_perfil: "foto_lidiane",
                                     pais: "Brasil",
                                     fluencia_ingles: "Advanced English"))
        
        self.usuarios.append(Usuario(id: 5,
                                     email: "bruna@icloud.com",
                                     senha: "moranguinho",
                                     nome: "Bruna Costa",
                                     foto_perfil: "foto_bruna",
                                     pais: "Brasil",
                                     fluencia_ingles: "Advanced English"))
        
        self.usuarios.append(Usuario(id: 6,
                                     email: "larissa@icloud.com",
                                     senha: "maezona",
                                     nome: "Larissa Diniz",
                                     foto_perfil: "foto_larissa",
                                     pais: "Brasil",
                                     fluencia_ingles: "Basic English"))
        
        self.usuarios.append(Usuario(id: 7,
                                     email: "jefferson@icloud.com",
                                     senha: "engenharia",
                                     nome: "Jefferson Silva",
                                     foto_perfil: "foto_jefferson",
                                     pais: "Brasil",
                                     fluencia_ingles: "Intermediate English"))
        
        self.usuarios.append(Usuario(id: 8, email: "juliana@icloud.com",
                                     senha: "sistemas",
                                     nome: "Juliana Prado",
                                     foto_perfil: "foto_juliana",
                                     pais: "Brasil",
                                     fluencia_ingles: "Intermediate English"))
        
        self.usuarios.append(Usuario(id: 9,
                                     email: "theo@icloud.com",
                                     senha: "violao",
                                     nome: "Theo Caldas",
                                     foto_perfil: "foto_theo",
                                     pais: "Brasil",
                                     fluencia_ingles: "Advanced English"))
        
        self.usuarios.append(Usuario(id: 10,
                                     email: "ana@icloud.com",
                                     senha: "artenapraia",
                                     nome: "Ana Ierusalimschy",
                                     foto_perfil: "foto_ana",
                                     pais: "Brasil",
                                     fluencia_ingles: "Intermediate English"))
        
    }
    
    func getSala(id: Int) -> Sala? {
        for sala in self.salas {
            if (id == sala.id) { return sala }
        }
        return nil
    }
    
    func getSalasByUser(id: Int) -> [Sala] {
        var salas: [Sala] = []
        for sala in self.salas {
            for membro in sala.membros {
                if (id == membro.usuario.id) { salas.append(sala) } 
            }
        }
        return salas
    }
    
    func getUsuario(id: Int) -> Usuario? {
        for user in self.usuarios {
            if (id == user.id) { return user }
        }
        return nil
    }
    
    func addNovaSala(_ sala: Sala){
        self.salas.append(sala)
    }
    
    func addNovoUsuario(_ usuario: Usuario){
        self.usuarios.append(usuario)
    }
}
