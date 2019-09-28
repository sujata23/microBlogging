

import Foundation
import UIKit

final class TempInMemoryCache : NSObject
{
    var imageCache = NSCache<NSString, UIImage>()
    
    static let sharedInstance: TempInMemoryCache = TempInMemoryCache()
    
    private override init()
    {
        super.init()
        
    }
    
    func insert(image : UIImage , key : String)
    {
        let keyToSet = key as NSString
        
        imageCache.setObject(image, forKey: keyToSet)
    }
    
    func imageForKey(keyTofetch : String?) -> UIImage?
    {
        
        guard let key = keyTofetch else {
            return nil
        }
        
        let keyAsObject = key as NSString
        
        return imageCache.object(forKey: keyAsObject)
        
    }
    
    func removeEntryForKey(_key : String)
    {
        guard _key != "" else {
            return
        }
        let keyAsObject = _key as NSString
        
        imageCache.removeObject(forKey: keyAsObject)
        
    }
    
    func removeAllCachedEntries()
    {
        imageCache.removeAllObjects()
    }
    
    
    
}
