//
//  ProfileView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 24/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dao: DAO
    
    var body: some View {
        Text("Profile View!")
            .fontWeight(.bold)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
