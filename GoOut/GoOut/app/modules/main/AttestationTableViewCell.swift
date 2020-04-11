//
//  AttestationTableViewCell.swift
//  GoOut
//
//  Created by Clément Casamayou on 11/04/2020.
//  Copyright © 2020 ClemCasa. All rights reserved.
//

import UIKit

class AttestationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = UIColor.white
    }

    func setData(title: String) {
        containerView.layer.borderColor = UIColor.init(rgb: 0x1F7B94).cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 5
        titleLabel.text = title
    }

}
