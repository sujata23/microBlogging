//
//  UtilityClass.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation


class UtilityClass
{
    
    public static var dateFormatterInstance = DateFormatter()

    //MARK : Date Converstion Utility functions
    
    /**
     
     The function will be used to convert "2017-12-05T02:18:18.571Z" string DateFormat
 
    */
    class func stringToDateFormat(dateInString : String) -> Date?
    {
        UtilityClass.dateFormatterInstance.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        UtilityClass.dateFormatterInstance.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = UtilityClass.dateFormatterInstance.date(from:dateInString)
        return date
        
    }
    
    
    /**
     
     The function will be used to convert Date to string "Sep 21, 2017"
     
     */
    
    class func dateToStringFormat(date : Date) -> String
    {
        UtilityClass.dateFormatterInstance.dateFormat = "MMM d, yyyy"
        let dateInString = UtilityClass.dateFormatterInstance.string(from: date)
        return dateInString
    }
}
