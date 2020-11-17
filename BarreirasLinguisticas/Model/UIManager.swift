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
    
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
        public func asUIImage() -> UIImage {
            let controller = UIHostingController(rootView: self)
            
            controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
            UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
            
            let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.sizeToFit()
            
    // here is the call to the function that converts UIView to UIImage: `.asImage()`
            let image = controller.view.asUIImage()
            controller.view.removeFromSuperview()
            return image
        }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension Data {
    public func asUIImage() -> UIImage? {
        return UIImage(data: self)
    }
}

extension UIImage {
    public func toData() -> Data? {
        return self.pngData()
    }
}

extension UIScreen {
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
}


struct LingoColors {
    static let lingoBlue = Color(red: 0, green: 162/255, blue: 1)
}
