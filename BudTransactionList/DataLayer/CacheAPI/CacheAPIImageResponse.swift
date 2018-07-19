//
//  CacheAPIImageResponse.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

/**
 This data structure will contain image response with image object and it's url
 */
struct CacheAPIImageResponse {
    
    /// The URL where image was downloaded from
    var imageURL: String
    
    /// The image object
    var image: UIImage?
    
    /// Image should not exceed this restrictions
    var targetSize: CGSize?
    
    /// Image returned from cache, not web server
    var isFromCache: Bool
}

/**
 This class returns web resources stored in the NSCache object. If object is not found in the cache then it download new object and updates the cache. Subscribe for notifications to be notified about rosource arrival.
 */
extension CacheAPI {
    
    /**
     Returns UIImage object for requested URL, if it is found in the cache. Otherwise it will call requestImage() method
     - parameter imageURL: URL for the requested image
     - parameter targetSize: If not nil then image will be resized from it's original size
     - returns: UIImage if it is found in the cache. Otherwise it will call requestImage() method
     */
    func getImage(imageURL: String, targetSize: CGSize?) -> UIImage? {
        
        /// Generate imageCacheKey
        let imageCacheKey = getImageCacheKey(imageURL: imageURL, targetSize: targetSize)
        
        /// Get the image
        if let chachedImage = imageCache.object(forKey: imageCacheKey) {
            return chachedImage
        } else {
            _ = requestImage(imageURL: imageURL, targetSize: targetSize)
        }
        
        /// Return nil if something went wrong
        return nil
    }
    
    /**
     Posting imageNotification with requested image. If image is found in the cache then you will get from cache. Otherwise it will be downloaded from requested URL location
     - parameter imageURL: URL for the requested image
     - parameter targetSize: If not nil then image will be resized from it's original size
     - returns: Return true if there was no error in request preparation and you should expect imageNotification
     */
    func requestImage(imageURL: String, targetSize: CGSize?) -> Bool {
        
        /// Generate imageCacheKey
        let imageCacheKey = getImageCacheKey(imageURL: imageURL, targetSize: targetSize)
        
        if let chachedImage = imageCache.object(forKey: imageCacheKey) {
            
            /// Return image asynchronously from cache
            DispatchQueue.global(qos: .background).async {
                let imageResponse = CacheAPIImageResponse(imageURL: imageURL, image: chachedImage, targetSize: targetSize, isFromCache: true)
                NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
            }
        } else {
            
            /// Try to create URL obect
            guard let url = URL(string: imageURL as String) else {
                print("ERROR: CacheAPI.getImage() - can't cretae URL object for url: \(imageURL)")
                return false
            }
            
            /// Get the image from url
            let urlRequest = URLRequest(url: url)
            budAPI.runDataTaskAndHandleErrors(urlRequest: urlRequest) { (data, error) in
                
                /// Make sure we have data returned back from server
                guard let data = data else {
                    print("ERROR: CacheAPI.getImage() - data response is nil for url: \(imageURL)")
                    let imageResponse = CacheAPIImageResponse(imageURL: imageURL, image: nil, targetSize: targetSize, isFromCache: false)
                    NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
                    return
                }
                
                /// Try to convert this data into UIImage
                guard let image = UIImage(data: data) else {
                    print("ERROR: CacheAPI.getImage() - can't create UIImage for url: \(imageURL)")
                    let imageResponse = CacheAPIImageResponse(imageURL: imageURL, image: nil, targetSize: targetSize, isFromCache: false)
                    NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
                    return
                }
                
                /// Resize image to feet into maxSize
                let resizedImage: UIImage
                if let targetSize = targetSize {
                    guard let _resizedImage = self.resizeImage(image: image, targetSize: targetSize) else {
                        print("ERROR: CacheAPI.getImage() - can'r resize image for url: \(imageURL)")
                        let imageResponse = CacheAPIImageResponse(imageURL: imageURL, image: nil, targetSize: targetSize, isFromCache: false)
                        NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
                        return
                    }
                    resizedImage = _resizedImage
                } else {
                    resizedImage = image
                }
                
                /// Save image to cache
                self.imageCache.setObject(resizedImage, forKey: imageCacheKey)
                
                /// Return this image to
                let imageResponse = CacheAPIImageResponse(imageURL: imageURL, image: resizedImage, targetSize: targetSize, isFromCache: false)
                NotificationCenter.default.post(name: CacheAPI.imageNotification, object: imageResponse)
            }
        }
        return true
    }
    
    /**
     Generate unque image cache key using imageURL and targetSize
     - parameter imageURL: URL for the requested image
     - parameter targetSize: If not nil then image will be resized from it's original size
     - returns: Image cache key
     */
    private func getImageCacheKey(imageURL: String, targetSize: CGSize?) -> NSString {
        if let targetSize = targetSize {
            return NSString(string: "url:\(imageURL) targetWidth:\(targetSize.width) targetHeight:\(targetSize.height)")
        } else {
            return NSString(string: "url:\(imageURL) originalSize")
        }
    }
    
    /**
     Resize image to the target size
     - important: This resize method preserve image width/height ratio
     - parameter imageURL: URL for the requested image
     - parameter targetSize: If not nil then image will be resized from it's original size
     - returns: Image of requested size
     */
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
