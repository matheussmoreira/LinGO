//
//  Link.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
//import UIKit
import LinkPresentation

class Link: NSObject, NSSecureCoding {
    var id: Int?
    var metadata: LPLinkMetadata?
    var image_provider: UIImage?
    
    static var supportsSecureCoding = true
    
    func encode(with coder: NSCoder) {
        guard let id = id, let metadata = metadata else { return }
        coder.encode(NSNumber(integerLiteral: id), forKey: "id")
        coder.encode(metadata as NSObject, forKey: "metadata")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(of: NSNumber.self, forKey: "id")?.intValue
        metadata = coder.decodeObject(of: LPLinkMetadata.self, forKey: "metadata")
    }
    
    func update(from metadata: LPLinkMetadata) {
        self.id = UUID().hashValue
        self.metadata = metadata
        getImage(metadata)
        saveLink(self.id) //para o Cache Management
    }
    
    func getImage(_ metadata: LPLinkMetadata){
        let md = metadata
        let _ = md.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { (image, err) in
            DispatchQueue.main.async {
                self.image_provider = image as? UIImage
            }
        })
    }
    
    override init() {
        super.init()
    }
    
    init (urlString: String) {
        super.init()
        LinkManager().getLink(url: urlString, to: self)
    }
    
    
}

//MARK: - Cache Management
extension Link {
    
    fileprivate func saveLink(_ id_link: Int?) {
        guard let id_link = id_link else {
            print("\nSaveLink: Received id as nil\n")
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent("Link \(id_link)"))
            //print(docDirURL.appendingPathComponent("Link \(id_link)"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadLink(_ id_link: Int?) -> Link? {
        guard let id_link = id_link else {
            print("\nLoadLink: Received id as nil\n")
            return nil
        }
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let linksURL = docDirURL.appendingPathComponent("Link \(id_link)")
        
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Link else { return nil }
                return unarchived
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    /*fileprivate func saveImage(_ id_link: Int?) {
        guard let id_link = id_link else {
            print("\nSaveImage: Received id as nil\n")
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIImage.self, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent("Image \(id_link)"))
            print(docDirURL.appendingPathComponent("Image \(id_link)"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadImage(_ id_link: Int?) -> UImage? {
        guard let id_link = id_link else {
            print("\nLoadImage: Received id as nil\n")
            return nil
        }
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let linksURL = docDirURL.appendingPathComponent("Image \(id_link)")
        
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIImage else { return nil }
                return unarchived
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }*/
}
