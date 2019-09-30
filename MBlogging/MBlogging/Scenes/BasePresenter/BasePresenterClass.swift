//
//  BaseWorkerClass.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 29/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation



class BasePresenterClass
{
    //MARK: Data modification function
    
    /**
     Modify date to show in post viewmodel
     */
    
    func dateModification(sourceDate : String?) -> String
    {
        guard let sourceDate = sourceDate else {
            return ""
        }
        
        guard sourceDate.trim().count != 0 else {
            return ""
        }
        
        let initialDate = UtilityClass.stringToDateFormat(dateInString: sourceDate.trim())
        
        var dateInString = ""
        
        if let initialDate = initialDate
        {
            dateInString = UtilityClass.dateToStringFormat(date: initialDate)
        }
        else
        {
            dateInString = ""
        }
        
        return dateInString
    }
    
   
}
