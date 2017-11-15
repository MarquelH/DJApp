//
//  ApiService.swift
//  DJ APP
//
//  Created by arturo ho on 11/13/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

typealias JSONDict = [String : AnyObject]

class ApiService: NSObject {
    
    static let shared = ApiService()
    
    private let baseURL = "https://itunes.apple.com/search?term="
    
    func fetchResults (term: String, completion: @escaping ([TrackItem]) -> ()) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let termWithEscapedCharacters = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.lowercased()
        //print(termWithEscapedCharacters)
        
        if let url = URL(string: "\(baseURL)\(termWithEscapedCharacters)&media=music") {
            URLSession.shared.invalidateAndCancel()
            
            //print("I created the URL: \(url.absoluteString)")
          
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                
                
                guard let data = data else {
                    print("no data")
                    return
                }
            
                var items = [TrackItem]()
                
                
                guard let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDict else {
                    print("Problem with json serialization")
                    return
                }
                
                guard let json = jsonDict, let results = json["results"] as? [JSONDict] else {
                    print ("Problem with JSON as results")
                    return
                }
                
                for result in results {
                    
                    
                    if let trackName = result["trackName"] as? String,
                        let trackArtist = result["artistName"] as? String,
                        let trackImageStr = result["artworkUrl100"] as? String,
                        let kind = result["kind"] as? String {
                        
                        guard let trackImage = URL(string: trackImageStr) else {
                            print("error with track image url")
                            return
                        }
                        
                        //Make sure we only add songs
                        if (kind == "song") {
                            let item = TrackItem(trackName: trackName, trackArtist: trackArtist, trackImage: trackImage)
                            items.append(item)
                        }
                    //print("Items size: \(items.count)")

                    }
                    
                }
                DispatchQueue.main.async(execute: {
                    completion(items)
                })
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
            task.resume()
            
        }
        
    }
    
    
}
