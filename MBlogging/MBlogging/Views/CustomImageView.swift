//
//  CustomImageView.swift
//
//  Copyright © 2017 Sujata Chakraborty. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


/**
  This subclass of UIImageview class will be used for
  Downloading image from URL and show in UIImageView
 */


public struct UIImageViewAlignmentMask: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    /// The option to align the content to the center.
    public static let center = UIImageViewAlignmentMask(rawValue: 0)
    /// The option to align the content to the left.
    public static let left = UIImageViewAlignmentMask(rawValue: 1)
    /// The option to align the content to the right.
    public static let right = UIImageViewAlignmentMask(rawValue: 2)
    /// The option to align the content to the top.
    public static let top = UIImageViewAlignmentMask(rawValue: 4)
    /// The option to align the content to the bottom.
    public static let bottom = UIImageViewAlignmentMask(rawValue: 8)
    /// The option to align the content to the top left.
    public static let topLeft: UIImageViewAlignmentMask = [top, left]
    /// The option to align the content to the top right.
    public static let topRight: UIImageViewAlignmentMask = [top, right]
    /// The option to align the content to the bottom left.
    public static let bottomLeft: UIImageViewAlignmentMask = [bottom, left]
    /// The option to align the content to the bottom right.
    public static let bottomRight: UIImageViewAlignmentMask = [bottom, right]
}

open class CustomImageView : UIImageView
{
    
    var titleLabel : UILabel?
    var highResImageURL : String?
    
    var highResImage : UIImage?
    public var fallbackImage : UIImage?
    
    var textColor : UIColor?
    var textColorWithOpacity : UIColor?
    var clearColor : UIColor?
    
    var operationQueue : OperationQueue?
    var operation : BlockOperation?
    
    //MARK: Init Methods
    
    override init(image: UIImage?) {
        super.init(image: image)
        setUpView()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame : frame)
        setUpView()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        
    }
    
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setUpView()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
    }
    
    func setFrame(frame : CGRect)
    {
    }
    
    //MARK: Styling Data
    
    func applyMissingStyle()
    {
        if (textColor != nil)
        {
            textColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        }
        
        titleLabel?.textColor = textColor
        
        titleLabel?.isHidden = false
        
    }
    
    func applyDefaultStyle()
    {
        if (textColor != nil)
        {
            titleLabel?.textColor = textColor
        }
        
        titleLabel?.isHidden = false
        
        if  (clearColor != nil)
        {
            clearColor = UIColor.clear
        }
        
        self.backgroundColor = clearColor
    }
    
    
    //MARK: View Set Up
    
    func setUpView()
    {
        if (operationQueue == nil)
        {
            operationQueue = OperationQueue()
            operationQueue?.maxConcurrentOperationCount = 1
            operationQueue?.name = "com.otg.imageLoader"
            
        }
        
        if (titleLabel == nil)
        {
            titleLabel = UILabel()
            titleLabel!.translatesAutoresizingMaskIntoConstraints = false
            titleLabel!.textColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            titleLabel!.numberOfLines = 0
            self.addSubview(titleLabel!)
        }
        
    }
    
    //MARK: Data Fetch and show
    
   @objc public func setHighResImageURL(highResImageURL : String? , title : String? , handler : ((_ success:Bool) -> Void)?)
    {
        
        self.highResImageURL = highResImageURL;
        
        if operationQueue != nil
        {
            operationQueue?.cancelAllOperations()
        }
        
        if  (highResImageURL == nil) || ( highResImageURL!.count <= 0)
        {
             self.image = nil
            if ((fallbackImage) != nil)
            {
                self.image = fallbackImage;
            }
            
            applyMissingStyle()
            
            if (handler != nil)
            {
                handler!(false)
            }
            
            return
            
        }
        
        
        
        titleLabel?.text = title ?? ""
        
        titleLabel?.isHidden = false
        
        let chachedImage = TempInMemoryCache.sharedInstance.imageForKey(keyTofetch: highResImageURL)
        
        if ( chachedImage != nil)
        {
            self.image = chachedImage;
            self.applyDefaultStyle()
            
            //check if handler is not nil execute it and return we don't need to
            // go any further
            if (handler != nil)
            {
                handler!(false)
                
            }
            return
        }
        
        //self.image = nil;
        
        operation = BlockOperation()
        weak var weakSelfoperation  = operation
        weak var weakSelf  = self
        
        operation?.addExecutionBlock {
            
            let shouldStart = weakSelfoperation?.isCancelled
            if (shouldStart == false)
            {
                
                    if  (weakSelf?.highResImageURL != nil)
                    {
                        ImageDownloader.downloadImageFromURL(url:(weakSelf?.highResImageURL!)!, handler: { (image : UIImage?, error : Error?) -> (Void) in
                            if weakSelf?.highResImageURL == highResImageURL
                            {
                            let shouldStart = weakSelfoperation?.isCancelled
                            
                            // check if image still needed
                            if (shouldStart == false)
                            {
                                // check if got an image
                                if (image != nil)
                                {
                                    // we have high res image we will use this
                                    weakSelf?.highResImage = image;
                                    
                                    DispatchQueue.main.async {
                                        
                                        weakSelf?.applyDefaultStyle()
                                        weakSelf?.image = weakSelf?.highResImage
                                        handler?(true)

                                    }
                                    
                                }
                                else
                                {
                                    
                                    DispatchQueue.main.async {
                                        if ((weakSelf?.fallbackImage) != nil)
                                        {
                                            handler?(false)
                                            // use background image instead
                                            weakSelf?.image = weakSelf?.fallbackImage;
                                        }
                                        else{
                                            // apply default missing image style
                                            weakSelf?.applyMissingStyle()
                                            handler?(false)

                                        }
                                    }
                                }
                                
                                }
                            }
                        })
                        
                    }

            }
            
        }
        
        operationQueue?.addOperation(operation!)
    }
    
    /**
     * Cancel any ongoing asynchronous image download requests
     */
    
    func cancelExistingRequest()
    {
        if operationQueue != nil
        {
            operationQueue?.cancelAllOperations()
        }
    }
    
    /**
     * @brief Use image as falback for when we're unable to retrieve a high res image. Must be called before a call to retrieve high/low res image.
     * @param fallbackImage - the image to use
     */
    
    public func setFallbackImageForRequest(fallBack : UIImage)
    {
        self.fallbackImage  = fallBack
    }
    //
    
    /**
     * @brief Call to set a background drop shadow as a placeholder while the image is being loaded. Must be called before a call to retrieve high/low res image.
     */
   public func setBackgroundDropshadowPlaceHolder()
    {
        let edgeInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 40, right: 40)
        let backgroundShadowImage = UIImage.init(named: "shadowImage")?.resizableImage(withCapInsets: edgeInset, resizingMode: UIImage.ResizingMode.stretch)
        self.image = backgroundShadowImage
    }
    
        
    

   
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    

}
