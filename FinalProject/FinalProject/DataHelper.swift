//
//  Data.swift
//  FinalProject
//
//  Created by iMac on 27/4/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

class DataHelper {
    static var instance : DataHelper = DataHelper()
    
    private let internalQueue: DispatchQueue = DispatchQueue(label:"LockingQueue")
    
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    var sectionHeaders = ["Configurations"]
    var data = [[" "]]
    var jsonArray = [Dictionary<String, Any>]()
    var loaded = false
    //var closure: (() -> Void)? = nil
    
    init() {
        fetch()
    }
    
    func fetch() {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            //print(json)
            //let resultString = (json as AnyObject).description
            let tmpArray = self.convert(array: json as! NSArray)
            self.assignData(data: tmpArray)
            for i in 0...self.jsonArray.count - 1 {
                let jsonDictionary = self.jsonArray[i]
                let jsonTitle = jsonDictionary["title"] as! String
                if self.data[0].count > i {
                    self.data[0][i] = jsonTitle
                } else {
                    self.data[0].append(jsonTitle)
                }
                //let jsonContents = jsonDictionary["contents"] as! [[Int]]
            }
            
            
            /*
             self.jsonArray = (json as? NSArray)!
             for i in 0...self.jsonArray.count - 1 {
             let jsonDictionary = self.jsonArray[i] as! NSDictionary
             let jsonTitle = jsonDictionary["title"] as! String
             if self.data[0].count > i {
             self.data[0][i] = jsonTitle
             } else {
             self.data[0].append(jsonTitle)
             }
             //let jsonContents = jsonDictionary["contents"] as! [[Int]]
             }
             */
            /*
             OperationQueue.main.addOperation {
             self.textView.text = resultString
             }
             */
            self.loaded = true
        }
    }
    
    func assignData(data: [Dictionary<String, Any>]) {
        internalQueue.sync {
        for i in 0...data.count - 1 {
            self.jsonArray.append(data[i])
        }
        }
    }
    
    private func convert(array: NSArray) -> [Dictionary<String, Any>] {
        var newArray = [Dictionary<String, Any>]()
        for i in 0...array.count - 1 {
            let jDictionary = array[i] as! NSDictionary
            let title = "title"
            let vTitle = jDictionary[title]
            
            let content = "contents"
            let vContent = jDictionary[content]
            var d = Dictionary<String, Any>()
            d[title] = vTitle
            d[content] = vContent
            newArray.append(d)
        }
        return newArray
    }
}
