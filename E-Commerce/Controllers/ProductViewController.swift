//
//  ProductViewController.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 02/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var productTableView: UITableView!
    var productsList:[Product]  = []
    override func viewDidLoad() {
        super.viewDidLoad()

        productTableView.register(UINib.init(nibName: "VariantsTableViewCell", bundle: nil), forCellReuseIdentifier:"VariantsTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 175
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:VariantsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VariantsTableViewCell", for: indexPath) as! VariantsTableViewCell
        cell.selectionStyle = .none
        let product = self.productsList[indexPath.row]
        
        if let name =  product.productName{
            cell.productTitleLabel.text = name
        }
        
        if let set = product.variants{
            cell.variantsList = set.allObjects  as! [Variant]
        }
        
        cell.relaodProducts()
        
        return cell
    }

}
