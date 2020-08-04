//
//  Link.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 25/07/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import LinkPresentation

class Link: NSObject, NSSecureCoding {
    var id: Int?
    var metadata: LPLinkMetadata?
    
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
        self.id = Int(Date.timeIntervalSinceReferenceDate)
        self.metadata = metadata
        //saveLink(self.id ?? 0) //para o cache
    }
    
    override init() {
        super.init()
    }
    
    init (urlString: String) {
        super.init()
        LinkManager().getLink(url: urlString, to: self)
    }
    
}

extension Link { //para o cache
    
    fileprivate func saveLink(_ id_link: Int) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            try data.write(to: docDirURL.appendingPathComponent("Link \(id_link)"))
            print(docDirURL.appendingPathComponent("Link \(id_link)"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadLink(_ id_link: Int?) -> Link? {
        guard let id_link = id_link else {
            print("\nReceived id as zero\n")
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
}
