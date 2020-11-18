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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var membro: Membro
    @ObservedObject var sala: Sala
    @ObservedObject var post: Post
//    @State private var stored_link: LinkPost?
    @State private var bookmarked = false
    @State private var bookmarkedImage = "bookmark"
    @State private var showComments = false
    @State private var reported = false
    @State private var showAlertExcluirPost = false
    @State private var showAlertReport = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    //AUTOR E NIVEL DE FLUENCIA
                    HStack {
                        Text("Shared by \(post.publicador.usuario.nome)")
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(post.publicador.usuario.fluencia_ingles/*.rawValue*/)
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .foregroundColor(post.publicador.usuario.cor_fluencia)
                    }
                    
                    //TAGS
                    HStack{
                        ForEach(0..<post.tags.count) { idx in
                            Text(self.post.tags[idx])
                                .foregroundColor(LingoColors.lingoBlue)
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    //DESCRICAO
                    Text(post.descricao!)
                        .padding(.bottom)
                        .multilineTextAlignment(.leading)
                    
                    //LINK PREVIEW
                    //                    if (stored_link != nil && stored_link?.metadata != nil) {
                    //                        LinkView(metadata: stored_link!.metadata!)
                    //                    }
                    if post.link != nil {
                        LinkPreview(link: post.link!)
                    }
                    
                    //MARK: - COMENTARIOS
                    Button(action: {self.showComments.toggle()}) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: UIScreen.width*0.95, height: 40.0)
                                .foregroundColor(LingoColors.lingoBlue)
                            HStack {
                                Spacer()
                                Text("Ask or Comment")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                    }
                    .sheet(isPresented: $showComments) {
                        CommentsQuestionsToggle(post: self.post)
                            .environmentObject(self.membro)
                    }
                    //MARK: - REPORT
                    
                    if !membro.isBlocked && membro.id != post.publicador.id {
                        Button(action:{
                            showAlertReport.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: UIScreen.width*0.95, height: 40.0)
                                    .foregroundColor(LingoColors.lingoBlue)
                                Text(reported ? "Dismiss Report" : "Report Post")
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .alert(isPresented: $showAlertReport) {
                            Alert(title: Text(reported ? "Dismiss report?" : "If you report, the admins of the room will be able to delete this post"),
                                  primaryButton: .default(Text(reported ? "Yes" : "Report")){
                                    self.report()
                                  },
                                  secondaryButton: .cancel())
                        }
                    }
                    
                    //MARK: - EXCLUIR POST
                    if (membro.id == post.publicador.id) || (post.denuncias.count>0 && membro.is_admin) {
                            Button(action: {
                                showAlertExcluirPost.toggle()
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: UIScreen.width*0.95, height: 40.0)
                                        .foregroundColor(LingoColors.lingoBlue)
                                    
                                    Text("Delete")
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                }.padding(.bottom)
                            }
                            .alert(isPresented: $showAlertExcluirPost) {
                                Alert(title: Text("Are you sure you want to delete this?"),
                                      primaryButton: .default(Text("Delete")){
                                        sala.excluiPost2(post: post, membro: membro)
                                        self.presentationMode.wrappedValue.dismiss()
                                      },
                                      secondaryButton: .cancel())
                            }
                    }
                    
                } //VStack
            } //ScrollView
            .frame(width: UIScreen.width*0.95)
            .onAppear {
//                self.carregaLink()
                self.loadBookmark()
            }
            .navigationBarTitle(
                Text(post.titulo)
            )
            .padding(.horizontal)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.changeBookmark()
                    }){
                        Image(systemName: bookmarkedImage)
                            .imageScale(.large)
                            .foregroundColor(.red)
                    }
            )
        }
        .onAppear{self.loadReport()}
    } //body
    
    func loadBookmark() {
        bookmarked = membro.posts_salvos.contains(post.id)
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
            membro.salvaPost(post: post.id)
        }
        else {
            bookmarkedImage = "bookmark"
            membro.removePostSalvo(post: post.id)
        }
    }
    
    func report(){
        post.updateReportStatus(membro: membro)
        reported = post.denuncias.contains(membro.id)
    }
    
    func loadReport(){
        reported = post.denuncias.contains(membro.id)
    }
    
}


//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView(sala: dao.salas[0], post:dao.salas[0].posts[0])
//            .environmentObject(dao.salas[0].membros[0])
//    }
//}
