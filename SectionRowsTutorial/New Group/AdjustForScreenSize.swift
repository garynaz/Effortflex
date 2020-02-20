//
//  AdjustForScreenSize.swift
//  SectionRowsTutorial
//
//  Created by Gary Naz on 2/20/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit

class Device {
    static let base: CGFloat = 414
    
    static var ratio: CGFloat {
        return UIScreen.main.bounds.width / base
    }
}

extension CGFloat {
    var adjusted: CGFloat{
        return self * Device.ratio
    }
}

extension Double {
    var adjusted: CGFloat{
        return CGFloat(self) * Device.ratio
    }
}

extension Int {
    var adjusted: CGFloat{
        return CGFloat(self) * Device.ratio
    }
}
