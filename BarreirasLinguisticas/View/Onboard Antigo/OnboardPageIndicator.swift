////
////  OnboardPageIndicator.swift
////  BarreirasLinguisticas
////
////  Created by Matheus S. Moreira on 18/08/20.
////  Copyright © 2020 Matheus S. Moreira. All rights reserved.
////
//
//import SwiftUI
//
//struct OnboardPageIndicator: View {
//    var currentIndex: Int = 0
//    var pagesCount: Int = 5
//    var onColor: Color = Color("lingoBlueBackgroundInverted")
//    var offColor: Color = Color.white
//    var diameter: CGFloat = 10
//    
//    var body: some View {
//        HStack{
//            ForEach(0..<pagesCount){ i in
//                Image(systemName: "circle.fill").resizable()
//                    .foregroundColor( i == self.currentIndex ? self.onColor : self.offColor)
//                    .frame(width: self.diameter, height: self.diameter)
//
//            }
//        }
//    }
//}
//
//struct OnboardPageIndicator_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardPageIndicator()
//    }
//}
