//
//  AdminView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    let btn_height: CGFloat = 50
    let btn_width: CGFloat = 230
    let corner: CGFloat = 45
    let lingoBlue = LingoColors.lingoBlue
    
    var body: some View {
        
        VStack{
            NavigationView {
                VStack {
                    Rectangle()
                        .frame(width: 60, height: 6)
                        .cornerRadius(3.0)
                        .opacity(0.1)
                        .padding(.top)
                    Spacer()
                    Text("What do you want to do?")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    NavigationLink(destination:
                                    PostsDenunciados()
                                    .environmentObject(sala)
                                    .environmentObject(membro)
                    ) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported posts")
                                    .foregroundColor(.white)
                            )
                    }
                    
                    NavigationLink(destination:
                                    ComentariosDenunciados()
                                    .environmentObject(sala)
                                    .environmentObject(membro)
                    ) {
                        RoundedRectangle(cornerRadius: corner)
                            .foregroundColor(lingoBlue)
                            .frame(height: btn_height)
                            .frame(width: btn_width)
                            .overlay(
                                Text("Check reported comments")
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Spacer()
                }.navigationBarHidden(true)
            }
        }
    }
}

struct PostsDenunciados: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State var posts: [Post] = []
    
    var body: some View {
        VStack{
            if posts.isEmpty{
                Text("No reported posts 🙂")
                    .foregroundColor(.gray)
            }
            else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(posts) { post in
                        NavigationLink(
                            destination: PostView(sala: sala, post: post)
                        ){
                            PostCardView(post: post, sala: sala, width: 0.85)
                                .environmentObject(membro)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(
            Text("Reported Posts")
        )
        .onAppear {
            self.posts = self.sala.posts.filter{!$0.denuncias.isEmpty}
        }
    }//body
}

struct ComentariosDenunciados: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @State private var comentariosDenunciados: [Comentario] = []
    
    var body: some View {
        VStack {
            if !comentariosDenunciados.isEmpty {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(comentariosDenunciados) { comentario in
                            ComentarioDenunciado(
                                comentario: comentario,
                                comentariosDenunciados: $comentariosDenunciados
                            )
                            .environmentObject(sala)
                            .environmentObject(membro)
                        }
                    }
                    Spacer()
                }
                
            } else {
                Text("No reported comments 🙂")
                    .foregroundColor(.gray)
            }
        }.navigationBarTitle(
            Text("Reported Comments")
        )
        .onAppear {
            self.carregaComentarios()
        }
    }
    
    func carregaComentarios(){
        self.comentariosDenunciados = []
        for post in sala.posts {
            self.comentariosDenunciados.append(
                contentsOf: post.perguntas.filter{!$0.denuncias.isEmpty}
            )
            self.comentariosDenunciados.append(
                contentsOf: post.comentarios.filter{!$0.denuncias.isEmpty}
            )
        }
    }
}

struct ComentarioDenunciado: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @ObservedObject var comentario: Comentario
    @State private var askApagaComentario = false
    @Binding var comentariosDenunciados: [Comentario]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(uiImage: comentario.publicador.usuario.foto_perfil?.asUIImage() ?? UIImage(named: "perfil")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40.0, height: 40.0)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(comentario.publicador.usuario.nome)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .frame(height: 20.0)
                        
                        Spacer()
                        
                        Text(comentario.publicador.usuario.fluencia_ingles.rawValue)
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .lineLimit(1)
                        
                        Circle()
                            .fill(comentario.publicador.usuario.cor_fluencia)
                            .frame(width: 10.0, height: 10.0)
                            .padding(.trailing)
                    }
                    Text(dao.getSala(id: membro.idSala)!.nome)
                        .frame(height: 6.0)
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                } //VStack
            } //HStack
            
            HStack {
                Text(comentario.conteudo)
                    .font(.body)
                    .padding(.all)
                    .lineLimit(10)
                    .frame(width: UIScreen.width*0.95)
                    .multilineTextAlignment(.leading)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            HStack {
                Button(action: {
                    askApagaComentario.toggle()
                }){
                    Image(systemName: "trash.circle")
                        .padding(.leading)
                        .imageScale(.large)
                }.alert(isPresented: $askApagaComentario) {
                    Alert(
                        title: Text("Delete this comment?"),
                        primaryButton: .default(Text("Delete")){
                            apagaComentario(comentario)
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer()
            }
            
            Divider()
        }.padding(.leading)
    }
    
    func apagaComentario(_ comentario: Comentario){
        if let post = sala.getPost(id: comentario.post) {
            if post.perguntas.contains(where: {$0.id == comentario.id}) {
                print("Apagando pergunta")
                post.apagaPergunta(id: comentario.id)
            }
            else if post.comentarios.contains(where: {$0.id == comentario.id}) {
                print("Apagando comentário")
                post.apagaComentario(id: comentario.id)
            }
        }
        carregaComentarios()
    }
    
    func carregaComentarios(){
        self.comentariosDenunciados = []
        for post in sala.posts {
            self.comentariosDenunciados.append(
                contentsOf: post.perguntas.filter{!$0.denuncias.isEmpty}
            )
            self.comentariosDenunciados.append(
                contentsOf: post.comentarios.filter{!$0.denuncias.isEmpty}
            )
        }
    }
}
