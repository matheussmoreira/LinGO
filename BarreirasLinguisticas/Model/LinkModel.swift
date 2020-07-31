//
//  LinkModel.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class LinkModel {
    //@Published var links = [Link]()
    
    func getLink(url: String) -> Link? {
        var link: Link?
        fetchMetadata(for: url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let metadata):
                    print("Case success")
                    link = self.createLink(metadata: metadata)
                case .failure(let error):
                    print("Case failure")
                    print(error.localizedDescription)
                    link = nil
                }
            } // DispatchQueue
        } // fetch
        return link
    }
    
     func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
           guard let url = URL(string: link) else { return }
           let metadataProvider = LPMetadataProvider()
           
           print("Fetching...")
           metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
               if let error = error  {
                   print("\nFetched: Error")
                   completion(.failure(error))
                   return
               }
               if let metadata = metadata {
                   print("\nFetched: Metadata")
                   completion(.success(metadata))
                   return
               }
           } // startFetchingMetadata
       }
    
    func createLink(metadata: LPLinkMetadata) -> Link {
        let link = Link()
        link.id = Int(Date.timeIntervalSinceReferenceDate)
        link.metadata = metadata
        /*links.append(link)
        saveLinks()*/
        return link
    }
    
    /*fileprivate func saveLinks() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: links, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent("links"))
            print(docDirURL.appendingPathComponent("links"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func loadLinks() {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let linksURL = docDirURL.appendingPathComponent("links")
     
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Link] else { return }
                links = unarchived
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    init() {
        loadLinks()
    }
    */
}
