//
//  OnboardElementView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct OnboardPageView: View {
    var element = Onboard.getAll.first!
    
    var body: some View {
            VStack{
                Image(element.image)
                VStack{
                    Text(element.heading).font(.title).bold().layoutPriority(1).multilineTextAlignment(.center)
                    Text(element.subSubheading)
                        .multilineTextAlignment(.center)
                }.padding()
            }
        
    }
}

struct OnboardElementView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardPageView()
    }
}
