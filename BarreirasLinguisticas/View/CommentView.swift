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
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.yellow)
                .frame(height: 80)
                .padding()
        
            VStack {
                HStack {
                    Image(comentario.publicador.usuario.foto_perfil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30.0, height: 30.0)
                        .clipShape(Circle())
                    Text(comentario.publicador.usuario.nome).fontWeight(.bold)
                    Spacer()
                }
                HStack {
                   Text(comentario.conteudo)
                    Spacer()
                }
            }
            .padding(.horizontal)
        } //ZStack
    } //body
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comentario: DAO().salas[0].posts[1].comentarios[0])
    }
}
