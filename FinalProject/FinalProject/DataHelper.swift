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
            self.addData(data: tmpArray)
            if self.jsonArray.count > 0  {
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
            }
            
            /*
             OperationQueue.main.addOperation {
             self.textView.text = resultString
             }
             */
            self.loaded = true
        }
    }
    
    func addData(data: [Dictionary<String, Any>]) {
        // make sure data concurrency
        internalQueue.sync {
            if data.count > 0 {
                for i in 0...data.count - 1 {
                    self.jsonArray.append(data[i])
                }
            }
        }
    }
    
    // Covert to a more familiar object!!!
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
    
    func formatNewData(title:String) -> Dictionary<String, Any> {
        var iArray = [[Int]]()
        var bArray = [[Int]]()
        var dArray = [[Int]]()
        var eArray = [[Int]]()
        let size = StandardEngine.instance.size
        for i in 0...size {
            for j in 0...size {
                switch StandardEngine.instance.grid[i, j] {
                case .alive:
                    iArray.append([i,j])
                case .born : bArray.append([i,j])
                case .died : dArray.append([i,j])
                default: eArray.append([i,j])
                }
            }
        }
        var dict = Dictionary<String, Any>()
        dict["title"] = title
        dict["contents"] = iArray
        dict["size"] = StandardEngine.instance.size
        if bArray.count > 0 {
            dict["born"] = bArray
        }
        if dArray.count > 0 {
            dict["died"] = dArray
        }
        return dict
    }
    
    func getData(title:String) -> Dictionary<String, Any>? {
        var result : Dictionary<String, Any>?
        if self.jsonArray.count > 0 {
            for i in 0...jsonArray.count - 1 {
                let jsonDictionary = jsonArray[i]
                let t = jsonDictionary["title"] as! String
                if title == t {
                    result = jsonArray[i]
                    break;
                }
            }
        }
        return result
    }
}
