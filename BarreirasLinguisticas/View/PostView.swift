//
//  PostView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 01/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import LinkPresentation

struct PostView: View {
    @EnvironmentObject var membro: Membro
    @ObservedObject var post: Post
    @State private var stored_link: Link?
    @State private var bookmarked = false
    @State private var bookmarkedImage = "bookmark"
    @State private var showComments = false
    @State private var reported = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading){
                    
                    Text(post.titulo)
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.top)
                    
                    //AUTOR E NIVEL DE FLUENCIA
                    HStack {
                        Text("Shared by \(post.publicador.usuario.nome)")
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(post.publicador.usuario.fluencia_ingles.rawValue)
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .foregroundColor(post.publicador.usuario.cor_fluencia)
                    }
                    
                    //TAGS
                    HStack{
//                        ForEach(post.tags) { tag in
//                            Text("#\(tag.nome)")
//                                .foregroundColor(LingoColors.lingoBlue)
//                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    //DESCRICAO
                    Text(post.descricao!)
                        .padding(.bottom)
                    
                    //LINK PREVIEW
                    if (stored_link != nil && stored_link?.metadata != nil) {
                        LinkView(metadata: stored_link!.metadata!)
                    }
                    
                } //VStack
            } //ScrollView
                .frame(width: UIScreen.width*0.95)
                .onAppear {
                    self.carregaLink()
                    self.loadBookmark()
            }
            .navigationBarTitle(
                Text(post.titulo)
                    .font(.system(.title, design: .rounded)),displayMode: .inline
            )
                .padding(.horizontal)
                .navigationBarItems(trailing:
                    Button(action: {self.changeBookmark()}){
                        Image(systemName: bookmarkedImage)
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
            )
            
            //MARK: - REPORT
            HStack {
                ZStack {
                    Capsule()
                        .frame(width: 100.0, height: 50.0)
                        .foregroundColor(.orange)
                    Button(reported ? "Dismiss" : "Report") {
                        self.report()
                    }
                    .foregroundColor(.primary)
                    .colorInvert()
                }
                .padding(.all)
                .foregroundColor(.red)
                
                Spacer()
                //MARK: - COMENTARIOS
                Button(action: {self.showComments.toggle()}) {
                    ZStack {
                        Capsule()
                            .frame(height: 50.0)
                            .foregroundColor(LingoColors.lingoBlue)
                        HStack {
                            Spacer()
                            Text("Ask or Comment")
                                .foregroundColor(.primary)
                                .colorInvert()
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundColor(.primary)
                                .colorInvert()
                            Spacer()
                        }
                    }
                }
                .padding(.all)
                .sheet(isPresented: $showComments) {
                    CommentsQuestionsToggle(post: self.post)
                        .environmentObject(self.membro)
                }
            } //sheet
        }.onAppear{self.loadReport()} //VStack
    } //body
    
    func carregaLink(){
        if let link = post.link {
            //stored_link = post.link
            stored_link = Link.loadLink(link.id) // do cache
        }
    }
    
    func loadBookmark() {
        bookmarked = membro.posts_salvos.contains(post)
        if bookmarked {
            bookmarkedImage = "bookmark.fill"
        }
        else {
            bookmarkedImage = "bookmark"
        }
    }
    
    func changeBookmark(){
        bookmarked.toggle()
        if bookmarked {
            bookmarkedImage = "bookmark.fill"
            membro.salvaPost(post: post)
        }
        else {
            bookmarkedImage = "bookmark"
            membro.removePostSalvo(post: post)
        }
    }
    
    func report(){
        if !post.denuncias.contains(membro) {
            post.denuncias.append(membro)
        }
        else {
            post.denuncias.removeAll(where: {$0.usuario.id == membro.usuario.id})
            //post.denuncias.remove(at: post.getDenunciaIndex(membro_id: membro.usuario.id))
        }
        reported = post.denuncias.contains(membro)
    }
    
    func loadReport(){
        reported = post.denuncias.contains(membro)
    }

}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post:DAO().salas[0].posts[0]).environmentObject(DAO().salas[0].membros[0])
    }
}
