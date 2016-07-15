//
//  RESTfulController.swift
//  RESTful
//
//  Created by Mark Drayton on 14/07/2016.
//  Copyright © 2016 Mark Drayton Ltd. All rights reserved.
//

import UIKit

class RESTfulController: NSObject {
    
    var config: NSURLSessionConfiguration?
    var session: NSURLSession?
    
    override init() {
        
        config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config!)
        
    }

    
    internal func fetch(collectionURL: String, dataItems: DataItems) -> Void {
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: collectionURL)!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        typealias Payload = [String: AnyObject]
        
        let task = session!.dataTaskWithRequest(urlRequest) {
            
            (data, response, error) in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("Error making GET request")
                return
            }

            do {
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions()) as? [Payload] else {
                    print("Error: could not convert data to json")
                    return
                }
                
                // reset the array
                dataItems.items = [DataItem]()
                
                //loop through items retrieved
                for jsonItem in json {
                    
                    guard (jsonItem["title"] as? String) != nil else {
                        print("Error: could not get title from json")
                        return
                    }
                    
                    guard (jsonItem["_id"] as? String) != nil else {
                        print("Error: could not get _id from json")
                        return
                    }
                    
                    //check for both the date created or updated
                    var _date : String = ""
                    if (jsonItem["created_at"] as? String) != nil {
                        _date = jsonItem["created_at"] as! String
                    } else if (jsonItem["updated_at"] as? String) != nil {
                        _date = jsonItem["updated_at"] as! String
                    } else {
                        print("Error: could not retrieve a date from JSON")
                        return
                    }

                    //create data item and append to array
                    let dataItem = DataItem(title: jsonItem["title"] as! String, createdDate: _date, id: jsonItem["_id"] as! String)
                    dataItems.items.append(dataItem)
                    
                }
                
                // refresh the table
                dispatch_async(dispatch_get_main_queue(), {
                    NSNotificationCenter.defaultCenter().postNotificationName("newValues", object: self)
                })
                
                
            } catch  {
                print("Error trying to convert data to JSON")
            }

            
        }
        task.resume()
    }
    
    
    
    internal func update(title: String, id: String, collectionURL: String, dataItems: DataItems) -> Void {
        
        let putUrl = collectionURL + "/" + id
        let updateRequest = NSMutableURLRequest(URL: NSURL(string: putUrl)!)
        updateRequest.HTTPMethod = "PUT"
        updateRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        updateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newItem = ["title": title]
        
        let jsonNewItem: NSData
        do {
            jsonNewItem = try NSJSONSerialization.dataWithJSONObject(newItem, options: [])
            updateRequest.HTTPBody = jsonNewItem
        } catch {
            print("Error: cannot create json")
            return
        }
        
        let task = session!.dataTaskWithRequest(updateRequest, completionHandler:{ _, _, _ in
            
            self.fetch(collectionURL, dataItems: dataItems)
            
        })
        task.resume()
        
    }
    
    
    internal func create(title: String, collectionURL: String, dataItems: DataItems) -> Void {
        
        let createRequest = NSMutableURLRequest(URL: NSURL(string: collectionURL)!)
        createRequest.HTTPMethod = "POST"
        createRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        createRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newItem = ["title": title]
        
        let jsonNewItem: NSData
        do {
            jsonNewItem = try NSJSONSerialization.dataWithJSONObject(newItem, options: [])
            createRequest.HTTPBody = jsonNewItem
        } catch {
            print("Error: cannot create json")
            return
        }
        
        let task = session!.dataTaskWithRequest(createRequest, completionHandler:{ _, _, _ in
        
            // reload the data and refresh the table
            self.fetch(collectionURL, dataItems: dataItems)
            
        })
        task.resume()
        
        
    }
    
    
    internal func delete(id: String, collectionURL: String, dataItems: DataItems) -> Void {
        
        let deleteUrl = collectionURL + "/" + id
        let deleteRequest = NSMutableURLRequest(URL: NSURL(string: deleteUrl)!)
        deleteRequest.HTTPMethod = "DELETE"
        
        
        let task = session!.dataTaskWithRequest(deleteRequest) {
            (data, response, error) in
            
            guard let _ = data else {
                print("Error: could not delete \(deleteUrl)")
                return
            }
            
            // reload the data and refresh the table
            self.fetch(collectionURL, dataItems: dataItems)
            
        }
        task.resume()
        
    }
    
}
