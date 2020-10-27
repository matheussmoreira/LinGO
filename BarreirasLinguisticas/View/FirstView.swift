//
//  OnboardView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

enum EnterMode {
    case signUp
    case logIn
    case none
}

struct FirstView: View {
    @EnvironmentObject var dao: DAO
    @State private var enterMode = EnterMode.none
    @State private var getStarted = false
    @State private var loggedIn = false
    
    var body: some View {
        VStack {
            if !loggedIn {
                if enterMode == .none {
                    OnboardView(enterMode: $enterMode)
                    //                OnboardContainer(signedIn: $signedIn,
                    //                                 viewControllers: Onboard.getAll.map{UIHostingController(rootView: OnboardPageView(element: $0))})
                    //                    .transition(.scale)
                    //                    .animation(.spring())
                }
                else if enterMode == .signUp {
                    NewUserView(loggedIn: $loggedIn)
                        .environmentObject(dao)
                        .transition(.opacity)
                        .animation(.easeOut)
                }
//                else {
//                    ContentView(loggedIn: $loggedIn, enterMode: $enterMode)
//                        .environmentObject(dao)
//                }
            } else {
                ContentView(
                    loggedIn: $loggedIn,
                    enterMode: $enterMode
                )
                    .environmentObject(dao)
            }
            
        } //VStack
    } //body
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}

//struct OnboardContainer<Onboard: View>: View {
//    @Binding var signedIn: Bool
//    var viewControllers: [UIHostingController<Onboard>]
//    @State var currentPage = 0
//
//    var body: some View {
//        ZStack {
//            Color("lingoBlueBackground")
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                OnboardViewController(controllers: viewControllers, currentPage: self.$currentPage)
//
//                OnboardPageIndicator(currentIndex: self.currentPage)
//
//                Button(action: {self.signedIn.toggle()}) {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .frame(width: 250.0, height: 40.0)
//                            .foregroundColor(.black)
//
//                        Text("Get started")
//                            .foregroundColor(.white)
//                    }
//                }.padding(.vertical)
//            }
//        } //ZStack
//    } //body
//}
