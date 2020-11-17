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

extension UIScreen {
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
}


struct LingoColors {
    static let lingoBlue = Color(red: 0, green: 162/255, blue: 1)
}

struct FileSystem {
    static func filePath(forId id: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(
                for: .documentDirectory,
                in: FileManager.SearchPathDomainMask.userDomainMask
        ).first else {
            return nil
        }
        return documentURL.appendingPathComponent(id + ".png")
    }
    
    static func storeImage(data: Data?, url: URL?, forId id: String) {
        if let pngRepresentation = data {
            if let filePath = url /*filePath(forId: id)*/ {
                do  {
                    try pngRepresentation.write(
                        to: filePath,
                        options: .atomic
                    )
                } catch let error {
                    print(#function)
                    print(error)
                }
            }
        }
    }
    
    static func retrieveImage(forId id: String) -> Data? {
        if let filePath = FileSystem.filePath(forId: id),
           let fileData = FileManager.default.contents(atPath: filePath.path){
            return fileData
        }
        return nil
    }
}
