//
//  ContentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            CategoriesView().tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            PublicationView().tabItem {
                Image(systemName: "command")
                Text("Publish")
            }
            HomeView().tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            ProfileView().tabItem {
                Image(systemName: "command")
                Text("My Profile")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
