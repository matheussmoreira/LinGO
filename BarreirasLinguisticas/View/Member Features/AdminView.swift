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
    var posts: [Post] {
        return sala.posts.filter{!$0.denuncias.isEmpty}
    }
    
    var body: some View {
        VStack{
            if posts.isEmpty {
                if !sala.allPostsLoaded && !sala.loadingPostsError {
                    /*
                     Nao carregou todos os posts, entao nao tem
                     como falar com certeza que eh pra mostrar a msg
                     "No posts for you"
                    */
                    VStack {
                        ProgressView("")
                    }.frame(height: 260)
                }  else {
                    Text("No reported posts 🙂")
                        .foregroundColor(.gray)
                }
            }
            else {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        ForEach(posts) { post in
                            NavigationLink(
                                destination: PostView(sala: sala, post: post)
                            ){
                                PostCardView(post: post, sala: sala, width: 0.85)
                                    .environmentObject(membro)
                            }
                        }
                        if !sala.allPostsLoaded && !sala.loadingPostsError {
                            VStack {
                                ProgressView("")
                            }.frame(height: 260)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(
            Text("Reported Posts")
        )
    }//body
}

struct ComentariosDenunciados: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    private var denunciados: [Comentario] {
        return checaDenuciados()
    }
    
    var body: some View {
        VStack {
            if !denunciados.isEmpty {
                VStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack {
                            ForEach(denunciados) { comentario in
                                ComentarioDenunciado(
                                    comentario: comentario
                                )
                                .environmentObject(sala)
                                .environmentObject(membro)
                            }
                            if !sala.allComentariosLoaded {
                                ProgressView("")
                            }
                        }.frame(width: UIScreen.width)
                    }
                    Spacer()
                }
                
            } else {
                if !sala.allComentariosLoaded {
                    ProgressView("")
                } else {
                    Text("No reported comments 🙂")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationBarTitle(
            Text("Reported Comments")
        )
    }
    
    private func checaDenuciados() -> [Comentario] {
        var denunciados: [Comentario] = []
        for post in sala.posts {
            denunciados.append(
                contentsOf: post.perguntas.filter{!$0.denuncias.isEmpty}
            )
            denunciados.append(
                contentsOf: post.comentarios.filter{!$0.denuncias.isEmpty}
            )
        }
        return denunciados
    }
}

struct ComentarioDenunciado: View {
    @EnvironmentObject var sala: Sala
    @EnvironmentObject var membro: Membro
    @ObservedObject var comentario: Comentario
    @State private var askApagaComentario = false
    
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
            }.padding(.trailing)
            
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
        }
        .padding(.leading)
        .padding(.top)
    }
    
    func apagaComentario(_ comentario: Comentario){
        if let post = sala.getPost(id: comentario.post) {
            if post.perguntas.contains(where: {$0.id == comentario.id}) {
                post.apagaPergunta(sala: sala, id: comentario.id)
            }
            else if post.comentarios.contains(where: {$0.id == comentario.id}) {
                post.apagaComentario(sala: sala, id: comentario.id)
            }
        }
    }
    
}
