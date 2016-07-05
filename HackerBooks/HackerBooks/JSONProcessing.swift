//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Iberfan on 2/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation
import UIKit
 /*
 {
 "authors": "Allen B. Downey ",
 "image_url": "http://hackershelf.com/media/cache/f3/fe/f3fec7d794709480759e9b311fb7f2ec.jpg",
 "pdf_url": "http://greenteapress.com/thinkpython/thinkpython.pdf",
 "tags": "python, cs",
 "title": "Think Python"
 }
 
 */
let authors = "authors"
let imageURL = "image_url"
let pdfURL = "pdf_url"
let tags = "tags"
let title = "title"

//MARK : - Aliases
typealias JSONObject        =   AnyObject
typealias JSONDictionary    =   [String : JSONObject]
typealias JSONArray         =   [JSONDictionary]

//MARK: - Decodification
func decode(bookList json: JSONDictionary) throws  -> AGTBook{
    
    // Validamos el dict
    guard let imageUrlString = json[imageURL] as? String,
        image_url = NSURL(string: imageUrlString),
        pdfUrlString = json[pdfURL] as? String,
        pdf_url = NSURL(string: pdfUrlString),
        bookTitle = json[title] as? String else{
            throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    
    
    
    guard let authorsString = json[authors] as? String,
    tagsString = json[tags] as? String else {
            throw HackerBooksErrors.wrongURLFormatForJSONResource
    }
    let authorsList =  authorsString.componentsSeparatedByString(",")
    let tagStringList = tagsString.componentsSeparatedByString(",")
    
    var tagList = [Tag]()
    for tagString in tagStringList{
        tagList.append(Tag(name: tagString))
    }
    
    return  AGTBook(title: bookTitle, img: image_url, pdfUrl: pdf_url, authors: authorsList, tags: tagList)
}


//MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray{
    
    if let url = bundle.URLForResource(name),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksErrors.jsonParsingError
    }
}

func loadJSONFromURL(fileURL url: NSURL) throws -> JSONArray{
    
    if let data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksErrors.jsonParsingError
    }
}
