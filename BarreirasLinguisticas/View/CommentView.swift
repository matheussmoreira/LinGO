//
//  CommentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject var comentario: Comentario
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        Image(comentario.publicador.usuario.foto_perfil)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comentario.publicador.usuario.nome)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .frame(height: 20.0)
                                
                                Spacer()
                                
                                Text(comentario.publicador.usuario.fluencia_ingles)
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                                    .lineLimit(1)
                                
                                Circle()
                                    .fill(comentario.publicador.usuario.cor_fluencia)
                                    .frame(width: 10.0, height: 10.0)
                                    .padding(.trailing)
                            }
                            Text("Apple Developer Academy | PUC-Rio | Brazil")
                                .frame(height: 6.0)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                        } //VStack
                    } //HStack
                    
                    HStack {
                        Text(comentario.conteudo)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .frame(height: 40)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Spacer()
                    }
                } //VStack
                
                HStack {
                    Image("foto_victor")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20.0, height: 20.0)
                        .clipShape(Circle())
                        .padding(.leading)
                    
                    TextField("Answer here", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        .font(.footnote)
                    
                } //HStack
                    .padding(.horizontal)
            }
        }//ZStack
            .padding()
    }
    
        /*ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.secondary)
                .frame(height: 80)
                .shadow(radius: 8)
                .padding()
            
            VStack {
                HStack {
                    Image(comentario.publicador.usuario.foto_perfil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30.0, height: 30.0)
                        .clipShape(Circle())
                        .padding(.leading)
                    
                    Text(comentario.publicador.usuario.nome).fontWeight(.bold)
                    
                    Spacer()
                    HStack {
                        Text(comentario.publicador.usuario.fluencia_ingles)
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Circle()
                            .fill(comentario.publicador.usuario.cor_fluencia)
                            .frame(width: 10.0, height: 10.0)
                            .padding(.trailing)
                    }
                    
                } //HStack
                HStack {
                    Text(comentario.conteudo)
                        .padding(.horizontal)
                        
                    Spacer()
                }
            } //VStack
            .padding(.horizontal)
        } //ZStack
    } //body
}*/
    
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comentario: DAO().salas[0].posts[1].comentarios[0])
    }
}

struct Topbar : View {
    
    @Binding var selected : Int
    
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.selected = 0
                
            }) {
                
                Text("Questions")
                    .frame(width: 25, height: 25)
                    .background(self.selected == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 0 ? .pink : .gray)
            
            Button(action: {
                
                self.selected = 1
                
            }) {
                
                Text("Comments")
                .frame(width: 25, height: 25)
                .background(self.selected == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selected == 1 ? .pink : .gray)
            
            }.padding(8)
            .background(Color.gray)
            .clipShape(Capsule())
            .animation(.default)
    }
}
