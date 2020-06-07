//
//  Exercise.swift
//  Effortflex
//
//  Created by Gary Naz on 6/5/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

struct Exercise {
    var day : String
    var workout : String
    var exercise : String
    var wsr : [[String:Any]]
    var key : String
}
