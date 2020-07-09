//
//  SnapshotExtensions.swift
//  Effortflex
//
//  Created by Gary Naz on 5/12/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

extension QuerySnapshot {
    func decoded<Type:Decodable>() throws -> [Type] {
        let objects:[Type] = try documents.map({try $0.decoded()})
        return objects
    }
}



extension QueryDocumentSnapshot {
    func decoded<Type:Decodable>() throws -> Type {
        let firestoreData = try JSONSerialization.data(withJSONObject: data(), options: [])
        let object = try JSONDecoder().decode(Type.self, from: firestoreData)
        
        return object
    }
}

