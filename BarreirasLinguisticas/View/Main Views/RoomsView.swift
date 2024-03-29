//
//  RoomsView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import CloudKit

struct RoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @State private var showAvailableRooms = false
    @State private var myRooms_selected = true
    @State private var searchRooms_selected = false
    @State private var myRoomsColor = Color.gray
    @State private var searchRoomsColor = Color.blue
    var usuario: Usuario
    
    var body: some View {
        VStack {
            ZStack {
                Color("lingoBlueBackground")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("lingoLogoWhiteCrop")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(width: 250)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: UIScreen.width-20, height: 40)
                        
                        //MARK: -  TOGGLE BAR
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
                    
                    if myRooms_selected {
                        MyRoomsView(usuario: usuario)
                            .environmentObject(dao)
                            .padding(.top)
                    } else {
                        SearchRoomsView(usuario: usuario)
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
    @State private var alertRoomName = false
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
                    
                    //MARK: - LISTA DAS MINHAS SALAS
                    if !minhasSalas.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                ForEach(minhasSalas) { sala in
                                    Button(action: {
                                        alteraSalaAtual(sala: sala)
    //                                    self.presentationMode.wrappedValue.dismiss()
    //                                    self.usuario.sala_atual = sala.id//sala
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
                                if !dao.allSalasLoaded {
                                    ProgressView("")
                                }
                            }
                        }
                    } else {
                        if !dao.allSalasLoaded {
                            ProgressView("")
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
                        .onTapGesture {
                            hideKeyboard()
                        }
                    
                    TextField("Name",text: $newRoomName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: UIScreen.width*0.85)
                        .padding(.bottom)
                    
                    Spacer()
                    
                    // MARK: - BOTAO PARA GERAR NOVA SALA
                    Button(action: {
                        if newRoomName == "" || nomeSalaExistente() {
                            // Manda alerta nome de sala invalido
                            self.alertRoomName.toggle()
                        } else {
                            roomCreation.toggle()
                            self.novaSala(
                                nome: newRoomName,
                                criador: self.usuario
                            )
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
                    }.alert(
                        isPresented: $alertRoomName,
                        content: {
                            Alert(
                                title: Text(newRoomName == "" ? "The room cannot have an empty name!" : "There is a room with this name already"),
                                message: nil,
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    )
                    
                    // MARK: - BOTAO PARA VOLTAR DA CRIACAO
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
    
    func nomeSalaExistente() -> Bool {
        return dao.getSalasNomes().contains(where: { $0 == newRoomName })
    }
    
    func novaSala(nome: String, criador: Usuario) {
        CKManager.saveSala(nome: nome) { (result) in
            switch result {
                case .success(let savedSala):
                    DispatchQueue.main.async {
                        salvaMembroCriador(sala: savedSala, usuario: criador)
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func salvaMembroCriador(sala savedSala: Sala, usuario criador: Usuario){
        let membro = Membro(usuario: criador, idSala: savedSala.id, is_admin: true)
        CKManager.saveMembro(membro: membro) { (result) in
            switch result {
                case .success(let savedMembro):
                    DispatchQueue.main.async {
                        salaGanhaPrimeiroMembro(sala: savedSala, membro: savedMembro)
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func salaGanhaPrimeiroMembro(sala: Sala, membro: Membro){
        sala.membros.append(membro)
        self.dao.addNovaSala(sala)
        CKManager.modifySala(sala)
    
    }
    
    func alteraSalaAtual(sala: Sala){
        self.usuario.sala_atual = sala.id
        dao.idSalaAtual = self.usuario.sala_atual
        dao.salaAtual = sala
        dao.membroAtual = sala.getMembroByUser(id: self.usuario.id)
        self.presentationMode.wrappedValue.dismiss()
        CKManager.modifyUsuario(user: self.usuario)
    }
}

struct SearchRoomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dao: DAO
    @State private var alertEnterRoom = false
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
                    VStack {
                        ForEach(salasDisponiveis) { sala in
                            ZStack {
                                Capsule()
                                    .frame(width: 300.0, height: 50.0)
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    
                                    alertEnterRoom.toggle()
    //                                verificaNovoMembro(sala: sala, usuario: usuario)
                                }) {
                                    Text(sala.nome)
                                        .foregroundColor(LingoColors.lingoBlue)
                                }
                                .alert(isPresented: $alertEnterRoom) {
                                    Alert(
                                        title: Text("Do you want do become a member of this room?"),
                                        primaryButton: .default(Text("Yes")){
                                            criaNovoMembro(sala: sala)
                                        },
                                        secondaryButton: .cancel())
                                }
                            }
                        }
                        if !dao.allSalasLoaded {
                            ProgressView("")
                        }
                    }
                }
                
            } else {
                if !dao.allSalasLoaded {
                    ProgressView("")
                } else {
                    Spacer()
                    Text("No available rooms yet 😕")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            
            Spacer()
            
        }
    }
    
//    func verificaNovoMembro(sala: Sala, usuario: Usuario){
//        CKManager.retrieveMembroOf(sala: sala, usuario: usuario) { (result) in
//            switch result {
//                case .success(let retrievedMembroOpt):
//                    DispatchQueue.main.async {
//                        if let retrievedMembro = retrievedMembroOpt {
//                            print("Sala ganha novo membro direto")
//                            salaGanhaNovoMembro(sala: sala, membro: retrievedMembro)
//                        } else {
//                            print("Sala cria novo membro e add ele")
//                            criaNovoMembro(sala: sala)
//                        }
//                    }
//                case .failure(let error):
//                    print(#function)
//                    print(error)
//            }
//        }
//    }
    
    func criaNovoMembro(sala: Sala){
        let membro = Membro(usuario: usuario, idSala: sala.id, is_admin: false)
        CKManager.saveMembro(membro: membro) { (result) in
            switch result {
                case .success(let savedMembro):
                    DispatchQueue.main.async {
                        salaGanhaNovoMembro(sala: sala, membro: savedMembro)
                    }
                case .failure(let error):
                    print(#function)
                    print(error)
            }
        }
    }
    
    func salaGanhaNovoMembro(sala: Sala, membro: Membro){
        sala.membros.append(membro)
        alteraSalaAtual(sala: sala)
        CKManager.modifySala(sala)
    }
    
    func alteraSalaAtual(sala: Sala){
        self.usuario.sala_atual = sala.id
        dao.idSalaAtual = self.usuario.sala_atual
        dao.salaAtual = sala
        dao.membroAtual = sala.getMembroByUser(id: self.usuario.id)
        self.presentationMode.wrappedValue.dismiss()
        CKManager.modifyUsuario(user: self.usuario)
    }
}
