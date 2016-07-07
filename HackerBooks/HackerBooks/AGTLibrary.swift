//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Iberfan on 7/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation

class AGTLibrary {
    
    typealias AGTBooks = [AGTBook]
    typealias AGTBooksByTag = [Tag : NSSet]
    
    //MARK: - Properties
    var books : AGTBooks
    var tags : [Tag]
    var booksByTag : AGTBooksByTag
    
    
    //MARK: - Inits
    init(){
        books = AGTBooks()
        tags = [Tag]()
        booksByTag = AGTBooksByTag()
        
        do{
            let json = try loadJSONFromURL()
            var tagAux = [Tag]()
            for dict in json{
                do{
                    let book = try decode(bookList: dict)
                    tagAux.appendContentsOf(book.tags)
                    books.append(book)
                }catch{
                    fatalError("Error while processing JSON")
                }
            }
            let setOfTags = NSSet.init(array: tagAux)
            tags = setOfTags.allObjects as! [Tag]
            tags.append(Tag(name: Favourite))
            
            
            
        }catch{
            fatalError("Error while loading JSON")
        }
    }
    
    
}

