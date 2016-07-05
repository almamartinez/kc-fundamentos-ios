//
//  Foundation.swift
//  HackerBooks
//
//  Created by Iberfan on 5/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation

extension NSBundle{
    
    func URLForResource(name: String?) -> NSURL?{
        
        let components = name?.componentsSeparatedByString(".")
        let fileTitle = components?.first
        let fileExtension = components?.last
        
        return URLForResource(fileTitle, withExtension: fileExtension)
        
    }
}