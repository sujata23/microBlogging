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
    
    //Represent Generic error
    case GeneralError = 100
    
    //Represent parse error
    case UnableToParseErrorJson
    
    //Represent server error
    case ServerError
    
    //Represent Network error
    case NetworkError
    
    //Represent Empty data error
    case EmptyData
}


let MBErrorDomainName = "MBError"

public class MBError : NSError {
    
    /**
     ErroCode type
     */
    
    public var errorCode = MBErrorCode(rawValue: 0)
    /**
     This error code, will need to triage issue. Should include while sending an error log message to ominture.
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
     additional information logged to Server.
     */
    public var mbErrorDebugInfo: String? = ""
    
    
    /**
     Init functions
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    public init(mbErrorCode errorCode: MBErrorCode) {
        super.init(domain: MBErrorDomainName, code: errorCode.rawValue, userInfo: nil)
        
        self.errorCode = errorCode
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
            
            
        case .NetworkError:
            errorCode = "MB04"

        case .EmptyData:
            errorCode = "MB05"
        }
        return errorCode
    }
    
   
    
    
    
}
