//
//  Tag.swift
//  HackerBooks
//
//  Created by Iberfan on 5/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation

let Favourite = "Favorito"
class Tag:Comparable, Hashable {
    
    //MARK: - Stored properties
    let name : String
    
    var hashValue: Int {
        get{
           return name.hashValue
        }
    }
    
    init(name : String){
        self.name=name
    }
    
}

func ==(lhs: Tag, rhs: Tag) -> Bool {
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.name == rhs.name
}
func < (lhs: Tag, rhs: Tag) -> Bool {
    guard (lhs.name != Favourite) else{
        return true
    }
    return lhs.name < rhs.name
}