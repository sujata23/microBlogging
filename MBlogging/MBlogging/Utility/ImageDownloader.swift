

import Foundation
import UIKit

final class ImageDownloader : NSObject
{
    
    var cacheDirectory : URL?
    var imageViewURLDic : Dictionary<String, Any>?
    var imageViewHandlerDic : Dictionary<String, Any>?
    var currentColor : Int?
    
    
    static let sharedInstance: ImageDownloader = ImageDownloader()
    
    //MARK: Init Method
    
    private override init()
    {
        imageViewURLDic = Dictionary()
        imageViewHandlerDic = Dictionary()
        
        super.init()
        
        
        let dirName = "mb"
        let appName = ProcessInfo.processInfo.processName
        let manager = FileManager.default
        let cacheDirectories = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        
        var finalURL : URL = cacheDirectories.last!
        
        finalURL = finalURL.appendingPathComponent(appName)
        cacheDirectory = finalURL.appendingPathComponent(dirName)
        
        do {
            try manager.createDirectory(at:cacheDirectory! , withIntermediateDirectories: true, attributes: nil)
            
            
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        clearOutAncientFiles()
    }
    
    
    func clearOutAncientFiles()
    {
        
        guard cacheDirectory != nil else{
            
            return
        }
        let manager = FileManager.default
        
        do {
            
            let  cachedFiles = try manager.contentsOfDirectory(at: cacheDirectory!, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
            
            // Create a randomly-named purge directory
            let purgeDir = cacheDirectory?.appendingPathComponent("purge\(arc4random())")
            
            
            do {
                try manager.createDirectory(at:purgeDir! , withIntermediateDirectories: true, attributes: nil)
                
                
            } catch let error as NSError {
                
                return
                    NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            // Move files older than two weeks into the purge directory
            // Do the first bit (scan files and move into purge dir) synchronously (doesn't take too long)
            for file in cachedFiles
            {
                let urlObj = file as URL
                let fileName = urlObj.lastPathComponent
                
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: urlObj.path) as Dictionary
                    
                    let created = attr[.creationDate] as? Date
                    let age = -((created?.timeIntervalSinceNow)!)
                    if (age > 15 * 24 * 3600) {
                        
                        do {
                            
                            try manager.moveItem(at: urlObj, to: (purgeDir?.appendingPathComponent(fileName))! )
                            
                            
                        } catch let error as NSError {
                            NSLog("Unable to create directory \(error.debugDescription)")
                        }
                    }
                    
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                
            }
            DispatchQueue.global(qos: .background).async {
                
                if  (purgeDir != nil)
                {
                    do
                    {
                        try manager.removeItem(at:purgeDir!)
                    }
                    catch let error as NSError {
                        NSLog("Unable to create directory \(error.debugDescription)")
                    }
                }
            }
            
            
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
    }
    
    //MARK: Cache related functions
    
    class func setdata(_data: Data, cacheKey : String , lifetime: Int)
    {
        
        let filename = ImageDownloader.sharedInstance.verifyString(title:cacheKey)
        let fileURL = self.sharedInstance.cacheDirectory?.appendingPathComponent(filename)
        
        if( fileURL != nil ) {
            
            do {
                
                try _data.write(to: fileURL!)
                
                // Rather than have a separate database, we store the expiration time
                // as the file's lastModifiedTime.  (Since this is a cache, and on iOS,
                // nothing else should be messing with - or even looking at - the files,
                // so the fact that the lastModifiedTimes are in the future shouldn't be
                // a problem.)
                
                let expiration = Date.init(timeIntervalSinceNow: Double(lifetime))
                let attrs = [FileAttributeKey.modificationDate:expiration]
                
                do {
                    
                    try FileManager.default.setAttributes(attrs, ofItemAtPath: fileURL!.path)
                    
                    
                } catch let error as NSError {
                    NSLog("Unable to create directory \(error.debugDescription)")
                }
                
                
            } catch let error as NSError {
                
                NSLog("Unable to create directory \(error.debugDescription)")
                
            }
        }
        
        
    }
    
    
    // Return the data stored for the given cache key.
    //
    // Pass in a pointer to a BOOL and, if the data's expired, we won't delete
    // it and return nil, but instead return the data and give the caller the
    // date the cache entry was created so that the caller can make an
    // If-modified-since request.
    //
    class func dataFor(cacheKey : String , cacheEntryCreated : Date?) -> (Data?,Date?)
    {
        let filename = ImageDownloader.sharedInstance.verifyString(title:cacheKey)
        
        let fileURL = ImageDownloader.sharedInstance.cacheDirectory?.appendingPathComponent(filename)
        
        var checkValue = false
        

            let data = try? Data.init(contentsOf: fileURL!)
            
            if (data == nil)
            {
                checkValue = true
            }
            
            do {
                
                let attrs = try FileManager.default.attributesOfItem(atPath: fileURL!.path)
                let expires = attrs[FileAttributeKey.modificationDate] as! Date
                
                if (expires > Date()) {
                    checkValue = true
                    return (data,nil)
                }
                
                
                if (checkValue == false) {
                    
                    let created = attrs[FileAttributeKey.creationDate] as! Date
                    return (data , created)
                    
                }
                else
                {
                    return (data , nil)

                    
                }
                
                
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            

        do {
            
            try FileManager.default.removeItem(at: fileURL!)
            
            
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        return (nil,nil)
        
    }
    
    func  httpResponseNotModified(error : Error?, response : URLResponse?) -> Bool
    {
        var status = false
        
        if response == nil
        {
            return false

        }
        
        if (error == nil)
        {
            status = true
        }
        
        let httpResponse = response as! HTTPURLResponse
        
        if ( httpResponse.statusCode == 304)
        {
            
            status = true
            
        }
        else {
            status = false
        }
        
        return status
    }
    
    func  httpResponseIsValid(error : Error?, response : URLResponse?, data : Data?) -> Bool
    {
        var status = false
        
        if error == nil && (data?.count)! > 0 {
            status = true
        }
        
        if status == true {
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode != Constants.kServerSuccessResponseCode {
                
                status = false
            }
            
        }
        return status
        
    }
    
    func httpResponseExpiryInSeconds(response : URLResponse) -> UInt
    {
        // Default time-to-live for images is 1 day
        let ttl = 24*3600;
        
        // Max we think reasonable is just over a 15 days
        let maxTtl = 15 * 24 * 3600;
        
        
        if !response.responds(to: #selector(getter: HTTPURLResponse.allHeaderFields)) {
            //NSLog(@"defaulting TTL to 24*3600");
            return UInt(ttl)
            // Not much else we can do
        }
        
        
        let finalResponse = response as! HTTPURLResponse
        let headers = finalResponse.allHeaderFields
        
        if let cacheControl = headers["Cache-Control"] as? String
        {
            
            
            let stringObj = cacheControl as NSString
            
            if cacheControl.count > 0{
                
                
                do {
                    let reMaxAge = try NSRegularExpression(pattern: "max-age\\s*=\\s*(\\d+)", options: [.caseInsensitive])
                    
                    var mMaxAge: [AnyObject] = reMaxAge.matches(in: cacheControl, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, cacheControl.count))
                    
                    if mMaxAge.count > 0 {
                        
                        let match: NSTextCheckingResult = mMaxAge[0] as! NSTextCheckingResult
                        let matchRange = match.range(at: 1)
                        let maxAgeStr: String = stringObj.substring(with:matchRange)
                        let seconds: UInt32 = UInt32(maxAgeStr)!
                        let ttlInCom = UInt32(maxTtl)
                        
                        if ((seconds < ttlInCom)) {
                            
                            return UInt(seconds)
                        }
                    }
                } catch {
                }
                
                
                
            }
            
        }
        
        
        return UInt(ttl);
    }
    
    
    
    class func downloadImageFromURL(url : String , handler :@escaping (UIImage?,Error?) -> Void )
    {
        //Create a cache key
        
        let cacheKey = ImageDownloader.sharedInstance.verifyString(title: url)
        //BOOL isJPEG = YES;
        //NSString *str = [url lowercaseString];
        // we will check if not png then it will be jpg or jpeg
        //if ([str rangeOfString:@".png"].location != NSNotFound)
        //{
        //    isJPEG = NO;
        //}
        // Check if we have data in cache
        let cachedDataAndDate = dataFor(cacheKey: cacheKey, cacheEntryCreated:nil)
        
        if ((cachedDataAndDate.0 != nil) && (cachedDataAndDate.1 == nil))
        {
            // We have data in cache and its valid
            // we will use this data
            // Createing image Using [UIImage iamgeWithData:data] will not
            // decode image, and in that case image will be decode on main
            // thread when will drwan first time on imageView.
            // So we will force decode image here.
            //UIImage *image = decodedImageFromData(cachedData,isJPEG);
            
            let image = UIImage.init(data: cachedDataAndDate.0!)
            
            if  (image != nil)
            {
                let resImage = ImageDownloader.sharedInstance.decode(image: image!)
                handler(resImage, nil)
            }
            else
            {
                
                handler(nil, nil)
                
            }
            
            
        }
        else
        {
            var image: UIImage?
            //TODO Error needs set
//            var error: NSError?
            
            // Create a request
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.url = URL.init(string: url)
            request.httpMethod = "GET"
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.timeoutInterval = 60
           
            // See what we got back
            let session = URLSession.shared
            
            var finalData : Data?
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                
                if ((cachedDataAndDate.0 != nil) && (ImageDownloader.sharedInstance.httpResponseNotModified(error: error, response: response) == true)) {
                    // We've got expired cache data, but the source on the web has not
                    // been modified since, so we can just re-use the cache data
                    finalData = cachedDataAndDate.0
                } else if (ImageDownloader.sharedInstance.httpResponseIsValid(error: error, response: response, data: data) == false) {
                    // Some problem was encountered
                    
                    // More output filtered due to trial limitations
                    finalData = nil
                    
                    if  error == nil{
                        
                        ////TVOS TEMPORARY COMMENTED , need to create error obj
                        
                        //error = Error(domain: "ImageDownloaderEmptyData", code: 404, userInfo: nil)
                    }
                    
                }else
                {
                    finalData = data
                }
                
                
                if (finalData != nil)
                {
                    
                    // Lets update our cache
                    
                    let ttl = ImageDownloader.sharedInstance.httpResponseExpiryInSeconds(response: response!)
                    
                    setdata(_data: finalData!, cacheKey: cacheKey, lifetime: Int(ttl))
                    // Createing image Using [UIImage iamgeWithData:data] will not
                    // decode image, and in that case image will be decode on main
                    // thread when will drwan first time on imageView.
                    // So we will force decode image here.
                    //image = decodedImageFromData(data,isJPEG);
                    image = UIImage.init(data: finalData!);
                    
                    if image != nil
                    {
                    let resImage = ImageDownloader.sharedInstance.decode(image: image!)
                    
                      handler(resImage, nil)
                    }
                    else
                    {
                       
                        handler(nil, nil)
                       
                    }
                    
                } else {
                    handler(nil, nil)
                }
                
            })
            
            task.resume()
            
            
        }
    }
    
    
    class func downloadImageWith(url : String , handler :@escaping (UIImage? , Error?) -> (Void))
    {
        if (url.count == 0)
        {
            
            handler(nil,nil);
            return;
        }
        let image = TempInMemoryCache.sharedInstance.imageForKey(keyTofetch:url)
        if (image != nil)
        {
            
            handler(image,nil);
            return;
        }
        
        self.downloadImageFromURL(url: url, handler: { (image: UIImage, error: NSError) in
            //        if (image)
            //        {
            //            [[TempInMemoryCache sharedInMemoryCache] insertImage:image forKey:url];
            //        }
            handler(image, nil)
            
            
            } as! (UIImage, NSError?) -> Void as! (UIImage?, Error?) -> Void)
    }
    
    
    //MARK: Utility Function
    
    func verifyString(title : String) -> String
    {
        var finalString : String?
        var charToDelete : String = ""
        
        
        for charToDetect in title {
            
            if ((charToDetect >= "A" && charToDetect <= "Z") ||
                (charToDetect >= "a" && charToDetect <= "z") ||
                (charToDetect >= "0" && charToDetect <= "9") ||
                charToDetect == "-" || charToDetect == "_" || charToDetect == "." || charToDetect == "+" || charToDetect == "@") {
                // It's okay
            } else {
                
                charToDelete.append(charToDetect)
                
            }
        }
        if (charToDelete != "") {
            
            for itemToDelete in charToDelete
            {
                finalString = title.replacingOccurrences(of: String(itemToDelete), with: "_")
                
            }
        }
        else
        {
            
            finalString = title
        }
        
        
        return finalString!
    }
    
    
    class func setImageViewContentMode(imageView: UIImageView , image : UIImage)
    {
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
    }
    
    func decode(image : UIImage) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0.0)
        image.draw(at: CGPoint.zero)
        UIGraphicsEndImageContext()
        
        return image
    }
}
