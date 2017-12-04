//
//  NetworkManager.swift
//  E-Commerce
//
//  Created by Roshan Nagose on 03/12/17.
//  Copyright © 2017 Roshan Nagose. All rights reserved.
//

import Foundation
class NetworkManager {
    
    // added for asyncoronous network call
    class func fetchProducts(_ completion:@escaping (_ data:NSDictionary?, _ error:Error?) -> ())
    {
        let url = URL(string: "https://stark-spire-93433.herokuapp.com/json")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            var json:NSDictionary!
            do {
                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            } catch let error as NSError {
                print(error)
            }
            
            completion(json , error)
            
        }).resume()
    }
}
