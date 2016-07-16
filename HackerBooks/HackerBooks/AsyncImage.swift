//
//  AsyncImage.swift
//  HackerBooks
//
//  Created by Iberfan on 16/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import Foundation
import UIKit

//MARK: - constants
let imageList = "ImageList"
let ImageDidLoadNotification = "Image Ends Loading"
let ImageKey = "imageKey"

class AsyncImage {
    //MARK: - alias
    typealias ImageClosure = (image: UIImage) -> ()
    
    //MARK: - Stored properties
    let urlImage : NSURL
    var imageLoaded : UIImage?
    
    //MARK: - Init
    init(urlImage : NSURL, placeHolder : UIImage?){
        self.urlImage = urlImage
        self.imageLoaded = placeHolder
        loadImage{(image: UIImage) in
            self.imageLoaded
        }
    }
    
   
    
    
    func sendEndLoadNotification() {
        //Enviamos misma info vía notificaciones
        let nc = NSNotificationCenter.defaultCenter()
        
        let notif = NSNotification(name: ImageDidLoadNotification, object: self, userInfo: [ImageKey:self] )
        nc.postNotification(notif)

    }
    
    func loadImage(completionClosure: ImageClosure){
        
        //Empezamos la descarga asíncrona
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0)){
            
            if let data = NSData(contentsOfURL: self.urlImage),
                img = UIImage(data: data){
                //Una vez terminada la descarga asíncrona, devolvemos la imagen, la guardamos en UserDefaults y lanzamos una notificación
                dispatch_async(dispatch_get_main_queue(),{
                    // UserDefaults
                    let usrDef = NSUserDefaults()
                    var listOfImages = usrDef.dictionaryForKey(imageList)
                    if listOfImages == nil{
                        listOfImages=[String : AnyObject]()
                    }
                    listOfImages![self.urlImage.absoluteString] = data
                    usrDef.setObject(listOfImages, forKey: imageList)
                    usrDef.synchronize()
                    
                    //Notificación
                    self.sendEndLoadNotification()
                    
                    //Completion
                    completionClosure(image: img)
                
                })
                
            }
        }
    }
}