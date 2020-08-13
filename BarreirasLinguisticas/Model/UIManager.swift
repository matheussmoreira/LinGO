//
//  UIManager.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 12/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIScreen {
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
}

struct LingoColors {
    static let lingoBlue = Color(red: 0, green: 162/255, blue: 1)
}
