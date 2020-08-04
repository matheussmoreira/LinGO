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
    
    func getLink(url: String, to link: Link) {
        fetchMetadata(for: url) { (result) in
            DispatchQueue.main.sync {
                switch result {
                case .success(let metadata):
                    print("Case success")
                    link.update(from: metadata)
                case .failure(let error):
                    print("Case failure: \(error.localizedDescription)")
                }
            } // DispatchQueue
        } // fetch
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
        } //startFetchingMetadata
    }
    
}
