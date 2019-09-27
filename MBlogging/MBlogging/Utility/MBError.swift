//
//  MBError.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 26/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation


/**
 Below are the error codes, each error should have an error code from list below.
 */

public enum MBErrorCode : Int {
    
    case GeneralError = 100
    case UnableToParseErrorJson
    case ServerError
    
}


let MBErrorDomainName = "MBError"

public class MBError : NSError {
    
    /**
     ErroCode type
     */
    
    public var erroCode = MBErrorCode(rawValue: 0)
    /**
     This sport error code, will need to triage issue. Should include while sending an error log message to ominture.
     */
    public var mbErrorCodeString: String? = ""
    /**
     The internal error description used for debuging and to loging error in ominture.
     */
    public var mbErrorInternalDescription: String? = ""
    /**
     The message to show the user, for example in a native alert popup.
     */
    public var mbErrorDescription: String? = ""
    
    /**
     additional information logged to Splunk.
     */
    public var mbErrorDebugInfo: String? = ""
    
    
    
    public init(mbErrorCode errorCode: MBErrorCode) {
        super.init(domain: MBErrorDomainName, code: errorCode.rawValue, userInfo: nil)
        
        erroCode = errorCode
        mbErrorCodeString = MBError.mbEsrrorCodeString(for: errorCode)
    }
    
    public class func mbEsrrorCodeString(for mbErrorCode: MBErrorCode) -> String {
        
        var errorCode: String = "0000"
        
        switch mbErrorCode {
            
        case .GeneralError :
            errorCode = "MB01"
            
        case .UnableToParseErrorJson:
            errorCode = "MB02"
            
        case .ServerError:
            errorCode = "MB03"
            
            
        }
        return errorCode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
