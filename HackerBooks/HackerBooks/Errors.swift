//
//  Errors.swift
//  HackerBooks
//
//  Created by Iberfan on 2/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation


// MARK: JSON Errors
enum HackerBooksErrors: ErrorType{
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
}