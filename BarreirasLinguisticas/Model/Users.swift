//
//  Users.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 30/10/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation
import CloudKitMagicCRUD

struct Users: CKMRecord, Codable {
    var recordName: String?
    var createdBy: String?
    var createAt: Date?
    var nome: String
    
}
