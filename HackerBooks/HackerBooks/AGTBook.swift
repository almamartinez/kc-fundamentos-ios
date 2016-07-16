//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Iberfan on 1/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation
import UIKit

let FavoriteDidChangeNotification = "isFavorite has changed"
let BookImageDidChangeNotification = "bookImage has changed"
let BookKey = "Book"

class AGTBook: Comparable {
    
    //MARK: - Stored Properties
    let title       : String
    let imgUrl         : NSURL
    let pdfUrl      : NSURL
    let authors     : [String]
    let tags        : [Tag]
    var isFavourite : Bool


    
    
    
    //MARK: - Initialization
    init(title : String, img : NSURL, pdfUrl : NSURL, authors : [String], tags : [Tag]){
        self.title      = title
        self.authors    = authors
        self.tags       = tags
        self.imgUrl     = img
        self.pdfUrl     = pdfUrl
        isFavourite     = false
        let usrDef = NSUserDefaults()
        if let listOfFavs = usrDef.arrayForKey(favoritesBooks){
            isFavourite = listOfFavs.contains({$0 as? String == self.title})
        }
        // Alta en notificaciones cuando cambia una imagen de un libro.
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(reloadBook), name: ImageDidLoadNotification, object: nil)

    }
    
    
    //MARK: - Computed properties
    var strAuthors  : String?{
        get{
            return authors.joinWithSeparator(",")
        }
    }
    
    var strTags : String?{
        get{
            var str = ""
            for tg in tags{
                str = str.stringByAppendingString(tg.name).stringByAppendingString(",")
            }
            str = str.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
            return str
        }
    }
    var bookImage : UIImage? {
        get{
            //Si está en userDefaults, lo devolvemos tal cual
            let usrDef = NSUserDefaults()
            if let listOfImages = usrDef.dictionaryForKey(imageList),
                data = listOfImages[imgUrl.absoluteString] as? NSData,
                img = UIImage(data:data){
                   return img
            }
            else{//Si no, cargamos la imagen asícronamente
                let placeHolder = UIImage(named: "placeholder.jpg")
                let img = AsyncImage(urlImage: imgUrl,placeHolder: placeHolder)
                return img.imageLoaded
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
    
    @objc
    func reloadBook(n : NSNotification)  {
        //Enviamos info vía notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        
        let notif = NSNotification(name: BookImageDidChangeNotification, object: self, userInfo: [BookKey : self])
        nc.postNotification(notif)
    }
   func changeFavorite(){
    
        let usrDef = NSUserDefaults()
        var listOfFavs = usrDef.arrayForKey(favoritesBooks)
        if listOfFavs == nil{
            listOfFavs=[AnyObject]?()
        }
        if isFavourite{
            //Eliminarlo de la lista
            let index = listOfFavs!.indexOf({$0 as? String == self.title})
            if !(index == nil){
                listOfFavs!.removeAtIndex(index!)
                isFavourite=false
            }
        }else{
            //Añadir a la lista
            listOfFavs!.append(self.title)
            isFavourite=true
        }
    
        usrDef.setValue(listOfFavs, forKey: favoritesBooks)
        usrDef.synchronize()
    
        //Enviamos info vía notificaciones
        let nc = NSNotificationCenter.defaultCenter()
    
        let notif = NSNotification(name: FavoriteDidChangeNotification, object: self, userInfo: [BookKey : self])
        nc.postNotification(notif)
   }
    
    var proxyForComparison : String{
        get{
            
            let str = "\(title)\(strAuthors)"
            var t = ""
            for each in tags.sort(){
                t = t.stringByAppendingString(each.name)
            }
            return str.stringByAppendingString(t)
        }
    }
    
}

func ==(lhs: AGTBook, rhs: AGTBook) -> Bool {
    guard (lhs !== rhs) else{
        return true
    }
    
    return (lhs.proxyForComparison == rhs.proxyForComparison)
    
}

func < (lhs: AGTBook, rhs: AGTBook) -> Bool {
    return lhs.title < rhs.title
}
