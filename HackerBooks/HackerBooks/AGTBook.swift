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
    let title       : String
    let imgUrl         : NSURL
    let pdfUrl      : NSURL
    let authors     : [String]
    let tags        : [Tag]


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
    init(title : String, img : NSURL, pdfUrl : NSURL, authors : [String], tags : [Tag]){
        self.title      = title
        self.authors    = authors
        self.tags       = tags
        self.imgUrl     = img
        self.pdfUrl     = pdfUrl
    }
    
    //MARK: - Computed properties
    var bookImage : UIImage {
        get{
            do{
                return try loadImage(fromURL: imgUrl)
            }catch{
                fatalError("Error while loading an Image")
            }
        }
    }
    
    var bookPdfData : NSData {
        get{
            do{
                return try loadPdf(fromURL: imgUrl)
            }catch{
                fatalError("Error while loading a Pdf")
            }

        }
    }
    
    
}
