//
//  AsyncPdf.swift
//  HackerBooks
//
//  Created by Iberfan on 17/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation


let PDFList = "PDFList"
let PDFDidLoadNotification = "PDFEndLoad"
let PDFKey = "PDFKey"

class AsyncPdf{
    
    //MARK: - alias
    typealias dataClosure = (pdfData: NSData) -> ()

    //MARK: - Properties
    let pdfUrl : NSURL
    let dataPDF : NSData?
    
    //MARK: - Inits
    init(pdfUrl : NSURL){
        self.pdfUrl = pdfUrl
        self.dataPDF = nil
        loadPDF{(pdfData: NSData) in
            self.dataPDF
        }
    }
    
    //MARK: - Methods
    
    func sendEndLoadNotification() {
        //Enviamos misma info vía notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        
        let notif = NSNotification(name: PDFDidLoadNotification, object: self, userInfo: [PDFKey:self] )
        nc.postNotification(notif)
        
    }
   
    func loadPDF(pdfClosure : dataClosure){
        //Empezamos la descarga asíncrona
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0)){
            
            if let data = NSData(contentsOfURL: self.pdfUrl)
                {
                //Una vez terminada la descarga asíncrona, devolvemos data, la guardamos en UserDefaults y lanzamos una notificación
                dispatch_async(dispatch_get_main_queue(),{
                    // UserDefaults
                    let usrDef = NSUserDefaults()
                    var listOfBooks = usrDef.dictionaryForKey(PDFList)
                    if listOfBooks == nil{
                        listOfBooks=[String : AnyObject]()
                    }
                    listOfBooks![self.pdfUrl.absoluteString] = data
                    usrDef.setObject(listOfBooks, forKey: PDFList)
                    usrDef.synchronize()
                    
                    //Completion
                    pdfClosure(pdfData: data)
                    
                    //Notificamos que terminó de cargar
                    self.sendEndLoadNotification()
                })
                
            }
        }

    }
    
}

