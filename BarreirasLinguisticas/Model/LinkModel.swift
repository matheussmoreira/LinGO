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
    
    func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
        guard let url = URL(string: link) else { return }
        
        let metadataProvider = LPMetadataProvider()
        metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
            if let error = error {
                //print("FetchMetaData: Erro")
                completion(.failure(error))
                return
            }
            if let metadata = metadata {
                //print("FetchMetaData: Sucesso")
                completion(.success(metadata))
            }
        }
    }
    
    func createLink(metadata: LPLinkMetadata, post: Post) -> Link {
        let link = Link()
        link.id = Int(Date.timeIntervalSinceReferenceDate)
        link.metadata = metadata
        post.link = link
        return link
    }
    
}
