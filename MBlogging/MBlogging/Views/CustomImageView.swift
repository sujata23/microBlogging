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
        updateLayout()
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
        setup()
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
    
        
    
    /**
     The technique to use for aligning the image.
     
     Changes to this property can be animated.
     */
    open var alignment: UIImageViewAlignmentMask = .center {
        didSet {
            guard alignment != oldValue else { return }
            updateLayout()
        }
    }
    
    open override var image: UIImage? {
        set {
            realImageView?.image = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.image
        }
    }
    
    open override var highlightedImage: UIImage? {
        set {
            realImageView?.highlightedImage = newValue
            setNeedsLayout()
        }
        get {
            return realImageView?.highlightedImage
        }
    }
    
    /**
     The option to align the content to the top.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignTop: Bool {
        set {
            setInspectableProperty(newValue, alignment: .top)
        }
        get {
            return getInspectableProperty(.top)
        }
    }
    
    /**
     The option to align the content to the left.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignLeft: Bool {
        set {
            setInspectableProperty(newValue, alignment: .left)
        }
        get {
            return getInspectableProperty(.left)
        }
    }
    
    /**
     The option to align the content to the right.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignRight: Bool {
        set {
            setInspectableProperty(newValue, alignment: .right)
        }
        get {
            return getInspectableProperty(.right)
        }
    }
    
    /**
     The option to align the content to the bottom.
     
     It is available in Interface Builder and should not be set programmatically. Use `alignment` property if you want to set alignment outside Interface Builder.
     */
    @IBInspectable open var alignBottom: Bool {
        set {
            setInspectableProperty(newValue, alignment: .bottom)
        }
        get {
            return getInspectableProperty(.bottom)
        }
    }
    
    open override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            layer.contents = nil
        }
        get {
            return super.isHighlighted
        }
    }
    
    /**
     The inner image view.
     
     It should be used only when necessary.
     Accessible to keep compatibility with the original `UIImageViewAligned`.
     */
    public private(set) var realImageView: UIImageView?
    
    private var realContentSize: CGSize {
        var size = bounds.size
        
        guard let image = image else { return size }
        
        let scaleX = size.width / image.size.width
        let scaleY = size.height / image.size.height
        
        switch contentMode {
        case .scaleAspectFill:
            let scale = max(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleAspectFit:
            let scale = min(scaleX, scaleY)
            size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            
        case .scaleToFill:
            size = CGSize(width: image.size.width * scaleX, height: image.size.height * scaleY)
            
        default:
            size = image.size
        }
        
        return size
    }
    

    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layer.contents = nil
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.contents = nil
        if #available(iOS 11, *) {
            let currentImage = realImageView?.image
            image = nil
            realImageView?.image = currentImage
        }
    }
    
    private func setup(image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        realImageView = UIImageView(image: image ?? super.image, highlightedImage: highlightedImage ?? super.highlightedImage)
        realImageView?.frame = bounds
        realImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        realImageView?.contentMode = contentMode
        addSubview(realImageView!)
    }
    
    private func updateLayout() {
        let realSize = realContentSize
        var realFrame = CGRect(origin: CGPoint(x: (bounds.size.width - realSize.width) / 2.0,
                                               y: (bounds.size.height - realSize.height) / 2.0),
                               size: realSize)
        
        if alignment.contains(.left) {
            realFrame.origin.x = 0.0
        } else if alignment.contains(.right) {
            realFrame.origin.x = bounds.maxX - realFrame.size.width
        }
        
        if alignment.contains(.top) {
            realFrame.origin.y = 0.0
        } else if alignment.contains(.bottom) {
            realFrame.origin.y = bounds.maxY - realFrame.size.height
        }
        
        realImageView?.frame = realFrame.integral
        
        // Make sure we clear the contents of this container layer, since it refreshes from the image property once in a while.
        super.image = nil
        layer.contents = nil

    }
    
    private func setInspectableProperty(_ newValue: Bool, alignment: UIImageViewAlignmentMask) {
        if newValue {
            self.alignment.insert(alignment)
        } else {
            self.alignment.remove(alignment)
        }
    }
    
    private func getInspectableProperty(_ alignment: UIImageViewAlignmentMask) -> Bool {
        return self.alignment.contains(alignment)
    }
    
}
