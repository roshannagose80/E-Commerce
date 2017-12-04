//
//  MainTabBarController.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 03/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController {

    let managedContext =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // make network call to get product list with category
        fetchAllProduct()
    }
    
    func fetchAllProduct(){
        
        NetworkManager.fetchProducts(){ (data, error) in
            DispatchQueue.main.async {
                // add data to local database
                if let _ = data {
                     self.saveResponse(data!)
                }
            }
        }
    }
    
    func saveResponse(_ resultData:NSDictionary) {
        
        if let categoryArray = resultData.value(forKey: "categories") as? NSArray {
            
            for item in categoryArray{
                
                if let dict = item as? NSDictionary,let catId = dict.value(forKey: "id") as? Int64  ,isCategoryExists(categoryId: catId) == false {
                    
                    let category = Category(context: managedContext)
                    
                    if let categoryId = dict.value(forKey: "id") as? Int64 {
                         category.categoryId = categoryId
                    }
                    
                    if let name = dict.value(forKey: "name") as? String {
                        category.categoryName = name
                    }
                    
                    if let products = dict.value(forKey: "products") as? NSArray {
                        
                        for productDict in products{
                           
                            if let productDict = productDict as? NSDictionary {
                                
                                let product = Product(context: managedContext)
                                
                                if let productId = productDict.value(forKey: "id") as? Int64 {
                                    product.productId = productId
                                }
                                
                                if let name = productDict.value(forKey: "name") as? String {
                                    product.productName = name
                                }
                                
                                if let variants = productDict.value(forKey: "variants") as? NSArray {
                                    
                                    for variantDict in variants{
                                        
                                        if let variantDict = variantDict as? NSDictionary {
                                            
                                            let variant = Variant(context: managedContext)
                                            
                                            if let variantId = variantDict.value(forKey: "id") as? Int64 {
                                                variant.variantId = variantId
                                            }
                                            
                                            if let color = variantDict.value(forKey: "color") as? String {
                                                variant.color = color
                                            }
                                            
                                            if let size = variantDict.value(forKey: "size") as? Int64 {
                                                variant.size = size
                                            }
                                            
                                            if let price = variantDict.value(forKey: "price") as? Int64 {
                                                variant.price = price
                                            }
                                            
                                            let variants = product.mutableSetValue(forKey: #keyPath(Product.variants))
                                            
                                            variants.add(variant)
                                        }
                                    }
                                    
                                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                                }

                                
                                let products = category.mutableSetValue(forKey: #keyPath(Category.products))

                                products.add(product)
                            }
                        }
                
                    }
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
        
        if let rankingArray = resultData.value(forKey: "rankings") as? NSArray {
            
            for item in rankingArray{
                
                if let dict = item as? NSDictionary,let rankingName = dict.value(forKey: "ranking") as? String  ,isRankingExists(rankingName:rankingName) == false {
                    
                    let ranking = Ranking(context: managedContext)
                    
                    if let rankingName = dict.value(forKey: "ranking") as? String {
                        ranking.rankingName = rankingName
                    }
                    
                
                    if let products = dict.value(forKey: "products") as? NSArray {
                        
                        for productDict in products{
                            
                            if let productDict = productDict as? NSDictionary {
                                
                                let rankedProduct = RankedProduct(context: managedContext)
                                
                                if let productId = productDict.value(forKey: "id") as? Int64 {
                                    rankedProduct.rankedProductId = productId
                                }
                                
                                if let order_count = productDict.value(forKey: "order_count") as? Int64 {
                                    rankedProduct.rankedCount = order_count
                                }
                                else if let name = productDict.value(forKey: "shares") as? Int64 {
                                    rankedProduct.rankedCount = name
                                }
                                else if let name = productDict.value(forKey: "view_count") as? Int64 {
                                    rankedProduct.rankedCount = name
                                }
                                
                                let rankingProducts = ranking.mutableSetValue(forKey: #keyPath(Ranking.rankProducts))
                                
                                rankingProducts.add(rankedProduct)
                            }
                        }
                        
                    }
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
        }
        
        // post notification to say network call is done
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductResults"), object: nil, userInfo: nil)
    }
    
    func isCategoryExists (categoryId:Int64) -> Bool {
        
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "categoryId == %d", argumentArray: [categoryId])
        
        fetchRequest.predicate = predicate
        
        do {
            let count = try managedContext.count(for:fetchRequest)
            
            if (count < 1) {
                return false
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return true
    }
    
    func isRankingExists (rankingName:String) -> Bool {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Ranking.fetchRequest()
        
        let predicate = NSPredicate(format: "rankingName == %@", argumentArray: [rankingName])
        
        fetchRequest.predicate = predicate
        
        do {
            let count = try managedContext.count(for:fetchRequest)
            
            if (count < 1) {
                return false
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
