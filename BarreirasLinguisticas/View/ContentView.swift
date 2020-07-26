//
//  ContentView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        TabView() {
            CategoriesView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Categories")
            }
            PublicationView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Publish")
            }
            HomeView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("Home")
            }
            ProfileView().environmentObject(self.dao).tabItem {
                Image(systemName: "command")
                Text("My Profile")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DAO())
    }
}
