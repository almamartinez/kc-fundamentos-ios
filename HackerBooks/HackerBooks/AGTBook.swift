//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Iberfan on 1/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation
import UIKit

class AGTBook {
    
    //MARK: - Stored Properties
    let title       : String?
    let img      : UIImage
    let pdfUrl      : NSURL
    let authors     : [String]
    let tags        : [String]


    var strAuthors  : String?{
        get{
            var str = ""
            for author in authors{
                str += author + ","
            }
            //str = str-1
            str.removeAtIndex(str.endIndex)
            return str
            
        }
    }
    
    //MARK: - Initialization
    init(title : String, img : UIImage, pdfUrl : NSURL, authors : [String], tags : [String]){
        self.title      = title
        self.authors    = authors
        self.tags       = tags
        self.img        = img
        self.pdfUrl     = pdfUrl
    }
    
}
