//
//  RoomsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct RoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @State private var showAvailableRooms = false
    @State private var myRooms_selected = true
    @State private var searchRooms_selected = false
    @State private var myRoomsColor = Color.gray
    @State private var searchRoomsColor = Color.blue
    
    var usuario: Usuario
    var salas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color("lingoBlueBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("lingoLogoWhite")
                        .padding()
                        .frame(width: 300, height: 200)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: UIScreen.width-20, height: 40)
                        
                        //MARK: -  TOGGLE BUTTONS
                        HStack {
                            HStack {
                                Button(action: {
                                    switchScreen(state: self.myRooms_selected)
                                }) {
                                    Text("My Rooms")
                                        .font(.subheadline)
                                        .foregroundColor(myRoomsColor)
                                }
                            }
                            .padding(.horizontal, 32)
                            
                            Divider()
                                .frame(height: 40)
                            
                            HStack {
                                Button(action: {
                                    switchScreen(state: self.searchRooms_selected)
                                }) {
                                    Text("Search Rooms")
                                        .font(.subheadline)
                                        .foregroundColor(searchRoomsColor)
                                }
                            }
                            .padding(.horizontal, 32)
                            
                        }
                    }
                    
                    //MARK: -  VIEW SELECIONADA
                    if myRooms_selected {
                        MyRoomsView(usuario: usuario)
                            .environmentObject(dao)
                            .padding(.top)
                    } else {
                        AvailableRoomsView(usuario: usuario)
                            .environmentObject(dao)
                            .padding(.top)
                    }
                }
                
            }
        }
    } //body
    
    func switchScreen(state isOn: Bool) {
        if !isOn {
            myRooms_selected.toggle()
            searchRooms_selected.toggle()
            if myRooms_selected {
                myRoomsColor = Color.gray
                searchRoomsColor = LingoColors.lingoBlue
            }
            else {
                myRoomsColor = LingoColors.lingoBlue
                searchRoomsColor = Color.gray
            }
        }
    }
    
}

//struct RoomsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomsView(usuario: DAO().usuarios[2])
//    }
//}

struct MyRoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @State private var roomCreation = false
    @State private var newRoomName = ""
    var usuario: Usuario
    var minhasSalas: [Sala] {
        return dao.getSalasByUser(id: usuario.id)
    }
    
    var body: some View {
        VStack {
            if !roomCreation {
                VStack {
                    Text("Select a room or create a new one!")
                        .font(.body)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.bottom, 50)
                    
                    //MARK: - MINHAS SALAS
                    if !minhasSalas.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(minhasSalas) { sala in
                                Button(action: { self.presentationMode.wrappedValue.dismiss()
                                    self.usuario.sala_atual = sala
                                }) {
                                    ZStack {
                                        Capsule()
                                            .frame(width: 300.0, height: 50.0)
                                            .foregroundColor(.white)
                                        Text(sala.nome)
                                            .foregroundColor(LingoColors.lingoBlue)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //MARK: -  BOTAO PLUS
                    Button(action: {
                        roomCreation.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .frame(width: 200.0, height: 50.0)
                                .foregroundColor(.green)
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.white)
                                Text("New Room")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    
                }
            } else {
                //MARK: - TELA DE CRIACAO DE NOVA SALA
                VStack {
                    Text("What is the name of the new room?")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.bold)
                    
                    TextField("Name",text: $newRoomName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.width*0.85)
                        .padding(.bottom)
                    
                    Spacer()
                    
                    // BOTAO PARA GERAR NOVA SALA
                    Button(action: {
                        if newRoomName != "" && newRoomName != " " {
                            roomCreation.toggle()
                            self.novaSala(
                                nome: newRoomName,
                                criador: self.usuario)
                        }
                    }) {
                        ZStack {
                            Capsule()
                                .frame(width: 200.0, height: 50.0)
                                .foregroundColor(.white)
                            HStack {
                                Text("Create!")
                                    .foregroundColor(LingoColors.lingoBlue)
                            }
                        }
                    }
                    
                    // BOTAO PARA VOLTAR
                    Button(action: {
                        roomCreation.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .frame(width: 200.0, height: 50.0)
                                .foregroundColor(.white)
                            HStack {
                                Text("Back")
                                    .foregroundColor(LingoColors.lingoBlue)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func novaSala(nome: String, criador: Usuario) {
        let sala = Sala(nome: nome)
        CKManager.saveSala(sala: sala) { (result) in
            switch result {
                case .success(let savedSala):
                    DispatchQueue.main.async {
                        print("saveSala: case.success")
                        primeiroMembro(sala: savedSala, usuario: criador)
                    }
                case .failure(let error):
                    print("saveSala: case.failure")
                    print(error)
            }
        }
    }
    
    func primeiroMembro(sala savedSala: Sala, usuario criador: Usuario){
        if let membro = savedSala.getNovoMembro(id: criador.id, usuario: criador, is_admin: true) {
            CKManager.saveMembro(membro: membro) { (result) in
                switch result {
                    case .success(let savedMembro):
                        DispatchQueue.main.async {
                            print("primeiroMembro: case.success")
                            atualizaSala(sala: savedSala, membro: savedMembro)
                        }
                    case .failure(let error):
                        print("primeiroMembro: case.failure")
                        print(error)
                }
            }
        }
    }
    
    func atualizaSala(sala: Sala, membro: Membro){
        sala.membros.append(membro)
        CKManager.updateSala(sala: sala) { (result) in
            switch result {
                case .success(let updatedSala):
                    DispatchQueue.main.async {
                        print("atualizaSala: case.success")
                        sala.membros = updatedSala.membros
                        self.dao.addNovaSala(sala)
                    }
                case .failure(let error):
                    print("atualizaSala: case.error")
                    print(error)
            }
        }
    }
}

struct AvailableRoomsView: View {
    @EnvironmentObject var dao: DAO
    var usuario: Usuario
    var salasDisponiveis: [Sala] {
        return dao.getSalasWithoutUser(id: usuario.id)
    }
    
    var body: some View {
        VStack{
            Text("Which room are you looking for?")
                .font(.body)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            if !salasDisponiveis.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(salasDisponiveis) { sala in
                        ZStack {
                            Capsule()
                                .frame(width: 300.0, height: 50.0)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                //                                self.dao.sala_atual = sala
                            }) {
                                Text(sala.nome)
                                    .foregroundColor(LingoColors.lingoBlue)
                            }
                        }
                    }
                }
                
            } else {
                Spacer()
                Text("No available rooms yet 😕")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            Spacer()
            
        }
    }
}
