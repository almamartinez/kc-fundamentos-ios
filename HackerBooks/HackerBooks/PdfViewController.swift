//
//  PdfViewController.swift
//  HackerBooks
//
//  Created by Iberfan on 17/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {

    //MARK: - Properties
    var model : AGTBook
    
    @IBOutlet weak var browser: UIWebView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    //MARK: - Init
    init(model : AGTBook){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Synchronizing
    func syncModelWithView() {
        browser.delegate=self
        self.title = model.title
        activityView.startAnimating()
        if let dataPdf = model.bookPdfData{
            browser.loadData(dataPdf, MIMEType: "application/pdf", textEncodingName: "UTF-8", baseURL:NSURL())
        }else{
            //Mostramos una alternativa y nos subscribimos a la notificación
            browser.loadHTMLString("<html><head></head><body><h1> Cargando contenido del libro...</h1></body></html>", baseURL: nil)
            let nc = NSNotificationCenter.defaultCenter()
            nc.addObserver(self, selector: #selector(didLoadPdfNotification), name: PDFDidLoadNotification, object: nil)
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Sólo hay que subscribirse a este mensaje en los ipad.
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            let nc = NSNotificationCenter.defaultCenter()
            nc.addObserver(self, selector: #selector(selectedBookChange), name:SelectedBookDidChangeNotification , object: nil)
        }
        
        syncModelWithView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - selectors
    func didLoadPdfNotification(notif : NSNotification) {
        if let data = model.bookPdfData{
            browser.loadData(data, MIMEType: "application/pdf", textEncodingName: "UTF-8", baseURL:NSURL())
        }
    }
    
    func selectedBookChange(notification : NSNotification){
        // Sacar el userInfo
        let info = notification.userInfo!
        
        // Sacar el character
        let book = info[BookKey] as? AGTBook
        
        // Actualizar el modelo
        model = book!
        
        // Sincronizar la vista
        syncModelWithView()
    }
    
    //MARK: - Delegado UIWebViewDelegate

    func webViewDidFinishLoad(webView: UIWebView){
        
        //Parar el activity view
        activityView.stopAnimating()
        
        // Ocultarlo
        activityView.hidden = true
    }

}
