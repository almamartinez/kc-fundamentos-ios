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


//MARK : - Aliases
typealias JSONObject        =   AnyObject
typealias JSONDictionary    =   [String : JSONObject]
typealias JSONArray         =   [JSONDictionary]

