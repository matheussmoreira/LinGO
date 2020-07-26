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
    
     class func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
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
                   //print("\(metadata.title!)\n")
                   completion(.success(metadata))
                   return
               }
           } // startFetchingMetadata
       }
    
    func createLink(metadata: LPLinkMetadata) -> Link {
        let link = Link()
        link.id = Int(Date.timeIntervalSinceReferenceDate)
        link.metadata = metadata
        return link
    }
    
}
