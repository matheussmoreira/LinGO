//
//  LinkPreview.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 11/11/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI

struct LinkPreview: View {
    private let width = UIScreen.main.bounds.width*0.95
    private var height: CGFloat { return width*0.4 }
    let link: LinkPost
    var imagem: Image? {
        if link.imagem != nil {
            return Image(uiImage: link.imagem!.asUIImage()!)
        } else {
            return nil
        }
    }
    
    var body: some View {
        if let linkurl = link.urlString {
            if let url = URL(string: linkurl) {
                Link(
                    destination: url,
                    label: {
                        VStack  {
                            if imagem != nil {
                                imagem!
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            
                            if link.titulo != nil {
                                Text(link.titulo!)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .padding(.horizontal)
                                    .padding(.top,8)
                                    .padding(.bottom,1)
                            }
                            
                            Text(link.urlString!)
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .padding(.horizontal)
                                .padding(.bottom,8)
                            
                        }
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
//                        .frame(
//                            width: width,
//                            height: height
//                        )
                    }
                )
            }
        }
    }
}

//struct LinkPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        LinkPreview()
//    }
//}
