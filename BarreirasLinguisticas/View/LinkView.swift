//
//  LinkView.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import UIKit
import LinkPresentation

struct LinkView: UIViewRepresentable {
    typealias UIViewType = LPLinkView
    var metadata: LPLinkMetadata?

    func makeUIView(context: Context) -> LPLinkView {
        guard let metadata = metadata
            else { return LPLinkView() }
        return LPLinkView(metadata: metadata)
    }
     
    func updateUIView(_ uiView: LPLinkView, context: Context) {
    } // do protocolo
    
}

