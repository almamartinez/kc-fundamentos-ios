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
let jsonLocalFile = "books_readable.json"
let jsonExternalFile = "https://t.co/K9ziV0z3SJ"

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
func loadFromLocalFile() -> JSONArray?{
    
    let fm = NSFileManager.defaultManager()
    let urls = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
    let url = NSURL.init(fileURLWithPath: jsonLocalFile, relativeToURL: urls.last)
    if let data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
        
    }else{
        return nil
    }
}

func loadJSONFromURL() throws -> JSONArray{
    
    guard let localArray = loadFromLocalFile() else{
        
        if let  url = NSURL(string: jsonExternalFile),
            data = NSData(contentsOfURL: url),
            array = try parseJSON(withData: data){
            print (saveToLocalUrl(data))
            return array
        }else{
            throw HackerBooksErrors.resourcePointedByURLNotReachable
        }
    }
    return localArray
}

func parseJSON(withData data : NSData) throws -> JSONArray? {
    if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        
        return array
    }else{
        throw HackerBooksErrors.jsonParsingError
    }

}

//
//let ImagesDefault = "imagesList"
func loadImage(fromURL url: NSURL) throws -> UIImage {
//    let usrDef = NSUserDefaults()
//    
//    guard var imagesList = usrDef.dictionaryForKey(ImagesDefault) else{
//        // No existe el diccionario, lo creamos
//        usrDef.setObject( , forKey: <#T##String#>)
//    }
//    
//    {
//        if let img = imagesList[url.absoluteString] as? UIImage{
//            return img
//        }
//        else {
//            //No existe la imagen, la descargamos y la metemos en el diccionario
//        }
//    }
//    else{
//        //Creamos el diccionario, lo almacenamos
//    }
    
    guard let data = NSData.init(contentsOfURL: url),
        image = UIImage.init(data: data) else{
            throw HackerBooksErrors.resourcePointedByURLNotReachable
    }
    return image
}
//

func loadPdf(fromURL url:NSURL) throws -> NSData {
    guard let data = NSData.init(contentsOfURL: url) else{
            throw HackerBooksErrors.resourcePointedByURLNotReachable
    }
    return data

}

func saveToLocalUrl(data : NSData){
    
    let fm = NSFileManager.defaultManager()
    let urls = fm.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
    let urlDir = NSURL.init(fileURLWithPath: jsonLocalFile, relativeToURL: urls.last)

    data.writeToURL(urlDir, atomically: true)
}






