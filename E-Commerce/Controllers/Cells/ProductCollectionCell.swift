//
//  ProductCollectionCell.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 03/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var productColorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainContentView.layer.cornerRadius = 4
        mainContentView.clipsToBounds = true;
        
    }

}
