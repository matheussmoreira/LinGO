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

class LinkPost: NSObject, NSSecureCoding {
    var id: Int?
    var metadata: LPLinkMetadata?
    var title: String?
    var url: String?
    var image: UIImage?
    
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
    
    override init() {
        super.init()
    }
    
    init? (urlString: String, completion: @escaping (Result<LinkPost, Error>) -> ()) {
        super.init()
        print("Construindo link...")
        LinkPost.fetchMetadata(for: urlString) { (result) in
            switch result {
                case .success(let metadata):
                    print("Sucesso ao pegar metadados")
                    self.id = UUID().hashValue
                    self.metadata = metadata
                    self.title = metadata.title
                    self.url = urlString//metadata.originalURL?.asString
                    self.getImage(metadata)
//                    self.saveLinkInCache(self.id)
                    completion(.success(self))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
            }
        }
    }
    
    func getImage(_ metadata: LPLinkMetadata){
        let md = metadata
        let _ = md.imageProvider?.loadObject(
            ofClass: UIImage.self,
            completionHandler: { (image, err) in
            DispatchQueue.main.async {
                self.image = image as? UIImage
            }
        })
    }
    
}

//MARK: - Link Manager
extension LinkPost {
    static func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
        guard let url = URL(string: link) else { return }
        let metadataProvider = LPMetadataProvider()
        
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            if let error = error  {
                completion(.failure(error))
                return
            }
            if let metadata = metadata {
                completion(.success(metadata))
                return
            }
        }
    }
}

//MARK: - Cache Manager
extension LinkPost {
    
    fileprivate func saveLinkInCache(_ id_link: Int?) {
        guard let id_link = id_link else {
            print("SaveLink: Received id as nil")
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
    
    static func fetchLinkFromCache(_ id_link: Int?) -> LinkPost? {
        guard let id_link = id_link else {
            print("LoadLink: Received id as nil")
            return nil
        }
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let linksURL = docDirURL.appendingPathComponent("Link \(id_link)")
        
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LinkPost else { return nil }
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
