//
//  WsrCell.swift
//  Effortflex
//
//  Created by Gary Naz on 7/12/20.
//  Copyright © 2020 Gari Nazarian. All rights reserved.
//

import UIKit

class WsrCell: UITableViewCell {
    
    var wsrLabel = UILabel()
    
    var deleteIcon = UIImage(systemName: "delete.left")
    var deleteImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 35))

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(wsrLabel)
        addSubview(deleteImageView)
        
        configureDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureDeleteButton(){
        deleteImageView.image = deleteIcon!
        
        deleteImageView.widthAnchor.constraint(equalToConstant: 45.adjusted).isActive = true
        deleteImageView.heightAnchor.constraint(equalToConstant: 35.adjusted).isActive = true
        
        wsrLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: deleteImageView.leadingAnchor)
        deleteImageView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5.adjusted, left: 0, bottom: 5.adjusted, right: 20.adjusted))
    }
    
}
