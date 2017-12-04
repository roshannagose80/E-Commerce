//
//  VariantsTableViewCell.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 03/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit

class VariantsTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var variantsCollectionView:UICollectionView!
    @IBOutlet weak var productTitleLabel: UILabel!
    var variantsList:[Variant]  = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.variantsCollectionView!.delegate = self;
        self.variantsCollectionView!.dataSource = self;
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.itemSize = CGSize(width: 156, height: 140);
        self.variantsCollectionView!.register(UINib(nibName:"ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        
        self.variantsCollectionView!.collectionViewLayout = flowLayout;
    }
    
    func relaodProducts() {
        self.variantsCollectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
       return self.variantsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        
        let  variant = self.variantsList[ indexPath.row]
       
        if let color = variant.color{
            cell.productColorLabel.text = "Color : \(color)"
        }
        else {
            cell.productColorLabel.text = ""
        }
        
        if let size = variant.size as? Int64 {
            cell.productSizeLabel.text = "Size : \(size)"
        }
        else {
            cell.productSizeLabel.text = ""
        }
        
        if let price = variant.price as? Int64 {
        
            cell.productPriceLabel.text = "Price : \(price)"
        }else {
            cell.productPriceLabel.text = ""
        }
        
        return cell
    }
    
}
