//
//  Exensions.swift
//  DJ APP
//
//  Created by arturo ho on 9/19/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension URL {
    
    func addHTTPS() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        if let host = components?.host {
            components?.host = host.replacingOccurrences(of: ".", with: "-ssl.", options: .caseInsensitive, range: host.range(of: "."))
        }
        return components?.url
    }
    
}

class ProfileImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageWithChachfromUrl(urlString: String) {
        
        //Do this if flashing occurs when scrolling. 
        //self.image =nil
        
        imageUrlString = urlString
        
        image = nil
        
        //check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
        }
        
        else {
            //Else fetch from URL
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if let error = error {
                    print("Adding values error: \n")
                    print(error.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        if self.imageUrlString == urlString {
                            self.image = downloadedImage
                        }
                        
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    }
                }
                
            }).resume()
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

