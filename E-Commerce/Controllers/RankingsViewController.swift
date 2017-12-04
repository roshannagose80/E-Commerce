//
//  RankingsViewController.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 03/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit
import CoreData

class RankingsViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var rankingLabel: UILabel!
    var pickerView: UIPickerView!
    var toolBar: UIToolbar!
    var rankingList:[Ranking] = []
    var productList : [Product] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var productTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // register  cell
        productTableView.register(UINib.init(nibName: "VariantsTableViewCell", bundle: nil), forCellReuseIdentifier:"VariantsTableViewCell")
        
        // call main data source that is local data base
        
        loadRankingData()
        
        // register  notification observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(RankingsViewController.loadRankingData), name: NSNotification.Name(rawValue: "ProductResults"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Service Methods
    
    // handle notification
    
    @objc func loadRankingData() {
        
        do {
            productList = try context.fetch(Product.fetchRequest())
            rankingList = try context.fetch(Ranking.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
        productTableView.reloadData()
    }

    
    // MARK: - General Methods
    
    // added picker with by programmatically
    func addRankingPicker() {
        
        if let _ =  self.toolBar{
            self.toolBar.removeFromSuperview()
        }
        
        if let _ =  self.pickerView{
            self.pickerView.removeFromSuperview()
        }
        
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y:UIScreen.main.bounds.size.height-280, width:UIScreen.main.bounds.size.width, height: 280))
        self.pickerView.backgroundColor = UIColor.white
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        toolBar = UIToolbar(frame: CGRect(x: 0, y: self.pickerView.frame.origin.y-44, width: self.pickerView.frame.size.width, height: 44))
        toolBar.backgroundColor = UIColor.white
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:#selector(RankingsViewController.pickerDoneAction(_:)))
        toolBar.setItems([doneButton], animated: false)
        
        self.view.addSubview(self.pickerView)
        self.view.addSubview(self.toolBar)
        
    }
    
    // apply filter for main data source depending on ranking selected
    func applyRankingFilter()
    {
        
        var  rankingProducts:[RankedProduct]!
        
        for ranking in rankingList {
            if ranking.rankingName == self.rankingLabel.text! {
                
                rankingProducts = ranking.rankProducts?.allObjects as! [RankedProduct]
                break;
            }
        }
        
        if let _ = rankingProducts{
           
            let ids = rankingProducts.map { $0.rankedProductId }
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Product.fetchRequest()
            
            let predicate = NSPredicate(format: "productId IN %@",ids)
            fetchRequest.predicate = predicate
            
            do {
                productList = try context.fetch(fetchRequest) as! [Product]
                
            } catch {
                print(error)
            }
        }
        
        productTableView.reloadData()
        
    }
    // MARK: - Action Methods
    
    @IBAction func rankingSelectionAction(_ sender: Any) {
        
        if rankingList.count>0 {
             addRankingPicker()
        }
    }
    
    // handle done button action on picker
    @objc func pickerDoneAction(_ sender: Any) {
        
        applyRankingFilter()
        
        if let _ =  toolBar{
            toolBar.removeFromSuperview()
        }
        
        if let _ =  self.pickerView{
            self.pickerView.removeFromSuperview()
        }
        
    }
    
    //MARK: - Picker Delegates and data sources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return rankingList.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let ranking = rankingList[row]
    
        if let name =  ranking.rankingName {
            return name
            
        }
        return ""
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let ranking = rankingList[row]
        
        if let name =  ranking.rankingName {
           rankingLabel.text = "\(name)"
        }
    }
    
    //MARK: - TableView Delegates and data sources
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 175
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:VariantsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VariantsTableViewCell", for: indexPath) as! VariantsTableViewCell
        cell.selectionStyle = .none
        let product = self.productList[indexPath.row]
        
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
