//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Iberfan on 7/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation
let ListOfFavsDidChangeNotification = "Favoritos ha cambiado"
class AGTLibrary {
    
    typealias AGTBooks = [AGTBook]
    typealias AGTBooksByTag = [Tag : NSSet]
    
    //MARK: - Properties
    var books : AGTBooks
    var tags : [Tag]
    var booksByTag : AGTBooksByTag
    
    let favTag = Tag(name: Favourite)
    //MARK: - Inits
    
    init(withBooks books: AGTBooks){
        
        
        self.books = books.sort()
       
        tags = [Tag]()
        
        booksByTag = AGTBooksByTag()
        
        // Alta en notificación
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(favoriteDidChange), name: FavoriteDidChangeNotification, object: nil)
        
        var tagDict = [Tag : AGTBooks]()
        tagDict[favTag] = AGTBooks()
        //Inicializo los tags y creo los arrays de libros por tag
        for book in self.books{
            for tag in book.tags{
                if tagDict[tag] == nil{
                    tagDict[tag] = AGTBooks()
                }
                tagDict[tag]?.append(book)
            }
            if book.isFavourite{
                tagDict[favTag]?.append(book)
            }
        }
        
        tags = tagDict.keys.sort()
        
        //Hago que los arrays de libros sean sets, para que no haya nada repetido.
        for tag in tags{
            booksByTag[tag] = NSSet(array:tagDict[tag]!)
        }
    }
    
    var strTags : String{
        get{
            var str=""
            tags.forEach({str = str.stringByAppendingString($0.name)})
            return str
        }
    }
    
    var booksCount : Int{
        get{
            return books.count
        }
    }
    
    func bookCountForTag (tag : Tag) -> Int{
        if let bookSet = booksByTag[tag]
        {
            return bookSet.count
        }
        return 0
    }
    
    func booksForTag (tag: Tag) -> AGTBooks? {
        if let bookSet = booksByTag[tag]{
            return bookSet.allObjects as? AGTBooks
        }
        return nil
    }
    
    func tagForIndex(index : Int) -> Tag{
        return tags[index]
    }
    
    func indexForTag(tag : Tag) -> Int? {
        if let index = tags.indexOf({$0 == tag}){
            return index
        }
        
        return nil
    
    }
    
    func indexForBook(book : AGTBook) -> Int? {
        if let index = books.indexOf({$0 == book}){
            return index
        }
       
        return nil
    }
    
    func indexForBook(book : AGTBook, atTag: Tag) -> Int? {
        if let booksAux = booksForTag(atTag),
            index = booksAux.indexOf({$0 == book}){
            return index
        }
        return nil
    }
       
    func bookAtIndex(index: Int, forTag : Tag) -> AGTBook? {
        if let list = booksForTag(forTag){
            return list[index]
        }
        return nil
    }
    
    @objc
    func favoriteDidChange(notification: NSNotification) {
        let info = notification.userInfo!
        let bk = (info[BookKey] as? AGTBook)!
        if bk.isFavourite{
            booksByTag[favTag] = booksByTag[favTag]?.setByAddingObject(bk)
        }else
        {
            if var list = booksForTag(favTag),
                let index = list.indexOf({$0 == bk}){
                list.removeAtIndex(index)
                
                booksByTag[favTag] = NSSet(array:list)
            }
        }
        
        //Enviamos notificación de cambio de favoritos.
        let nc = NSNotificationCenter.defaultCenter()
        //No necesita pasar user info, siempre es lo mismo lo que cambia, sólo hay que actualizar favoritos.
        let notif = NSNotification(name: ListOfFavsDidChangeNotification, object: self, userInfo: nil)
        nc.postNotification(notif)
        
    }
}

