//
//  OnboardElement.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

struct OnboardElement: Identifiable {
    let id: UUID
    let image: String
    let heading: String
    let subSubheading: String
    
    static var getAll: [OnboardElement] {
        [
            OnboardElement(id: UUID(), image: "", heading: "", subSubheading: "")
        ]
    }
}
