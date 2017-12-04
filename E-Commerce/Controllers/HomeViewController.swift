//
//  HomeViewController.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 02/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,SwipeViewDelegate, SwipeViewDataSource {

    @IBOutlet weak var segementedControl: HMSegmentedControl!
    @IBOutlet weak var parentView: SwipeView!
    var controllerList: [UIViewController] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call main data source that is local data base
        loadCategoryData()
        
        // register  notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.loadCategoryData), name: NSNotification.Name(rawValue: "ProductResults"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Service Methods
    
    // handle notification for getting data from local database
    @objc func loadCategoryData() {
    
        do {
            categoryList = try context.fetch(Category.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        
        if categoryList.count>0 {
            loadMainCategoryTab()
        }
        
    }

    // MARK: General Methods
    
    // added for loading main category with top tab bar
    func loadMainCategoryTab(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var tabNames:Array<String> = []
        
        for i in 0 ..< self.categoryList.count {
            
            let category = self.categoryList[i];
            
            tabNames.append(category.categoryName!)
            let productViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            if let set = category.products{
                productViewController.productsList = set.allObjects  as! [Product]
            }
            
            controllerList.insert(productViewController, at: i)
        }
        
        
        segementedControl.sectionTitles = tabNames
        segementedControl.isHidden = false
        segementedControl.selectionIndicatorHeight = 2.0
        segementedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segementedControl.type = HMSegmentedControlTypeText
        segementedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segementedControl.selectionIndicatorColor = UIColor(red: 110/255.0, green: 166/255, blue: 56/255, alpha: 1.0)
        segementedControl.addTarget(self, action: #selector(HomeViewController.segmentedControlChangedValue), for: UIControlEvents.valueChanged)
        segementedControl.setNeedsDisplay()
        
        
        parentView.delegate = self;
        parentView.isScrollEnabled =  false
        parentView.dataSource = self
        
        parentView.reloadData()
        
    }
    
    
    // handle action on segmented Control when Value changed
    
    @objc func segmentedControlChangedValue() {
        
        let selectedIndex = Int(segementedControl.selectedSegmentIndex);
        parentView.scrollToItem(at: NSInteger(selectedIndex), duration: 0.2)
        
    }
    
    func numberOfItems(in swipeView: SwipeView!) -> Int {
        return self.categoryList.count
    }
    
    //swipe view when segemented control index changed
    
    func swipeView(_ swipeView: SwipeView!, viewForItemAt index: Int, reusing view: UIView!) -> UIView! {
        if controllerList.count > 0 {
            let controller = controllerList[index]
            controller.view.frame = CGRect(x: 0, y: 0, width: swipeView.bounds.width, height: swipeView.bounds.height)
            return controller.view
        }
        return nil
        
    }
    
    func swipeViewCurrentItemIndexDidChange(_ swipeView: SwipeView!) {
        print(parentView.currentItemIndex)
        if !swipeView.isScrolling {
            
        }
    }
}
