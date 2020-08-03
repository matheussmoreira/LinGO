//
//  LinkManager.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 31/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class LinkManager: ObservableObject {
    var saved_link = Link()
    
    func getLink(url: String) -> Link? {
        var link: Link?
        fetchMetadata(for: url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let metadata):
                    print("Case success")
                    link = self.createLink(metadata)
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
                   print("\nFetched error")
                   completion(.failure(error))
                   return
               }
               if let metadata = metadata {
                   print("\nFetched metadata")
                   completion(.success(metadata))
                   return
               }
           } // startFetchingMetadata
       }
    
    func createLink(_ metadata: LPLinkMetadata) -> Link {
        let link = Link()
        link.id = Int(Date.timeIntervalSinceReferenceDate)
        link.metadata = metadata
        saveLink(link.id!)
        return link
    }
    
    fileprivate func saveLink(_ id_link: Int) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: saved_link, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent("Link \(id_link)"))
            print(docDirURL.appendingPathComponent("Link \(id_link)"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*fileprivate */func loadLink(_ id_link: Int) -> Link? {
        if id_link == 0 {
            print("\nReceived id as zero\n")
            return nil
        }
        
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let linksURL = docDirURL.appendingPathComponent("Link \(id_link)")
     
        if FileManager.default.fileExists(atPath: linksURL.path) {
            do {
                let data = try Data(contentsOf: linksURL)
                guard let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Link else { return nil }
                saved_link = unarchived
            } catch {
                print(error.localizedDescription)
            }
        }
        return saved_link
    }
    
}
