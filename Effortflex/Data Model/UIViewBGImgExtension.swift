//
//  UIViewBGImgExtension.swift
//  Effortflex
//
//  Created by Gary Naz on 7/8/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func addBackground(image:String) {
    // screen width and height:
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    imageViewBackground.image = UIImage(named: "\(image)")
    imageViewBackground.alpha = 0.5
    // you can change the content mode:
    imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

    self.addSubview(imageViewBackground)
    self.sendSubviewToBack(imageViewBackground)
}}
