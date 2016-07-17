//
//  LibraryViewControler.swift
//  HackerBooks
//
//  Created by Iberfan on 14/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import UIKit

let SelectedBookDidChangeNotification = "switch books"

class LibraryViewControler: UITableViewController, ListOfFavoritesChangedDelegate  {

    //Esta tabla va a contener los libros ordenados alfabéticamente

    //MARK: - Properties
    let model : AGTLibrary
    var delegate : LibraryViewControllerDelegate?
       //MARK: - Initialize
    init(model : AGTLibrary){
        self.model = model
      
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        // Alta en notificaciones cuando cambia una imagen de un libro.
        self.title = "Lista de Libros"
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(reloadCell), name: BookImageDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }
    
    //MARK: - Selector
    @objc
    func reloadCell(notif : NSNotification){
        if let book = notif.userInfo?[BookKey] as? AGTBook,
            index = model.indexForBook(book){
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let visibleIndexPaths = tableView.indexPathsForVisibleRows
            if ((visibleIndexPaths?.contains(indexPath)) != nil){
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Averiguar cual es el libro
        let book = model.books[indexPath.row]
        
    
        // Avisar al delegado
        delegate?.libraryViewController(self, didSelectBook: book)
               
        
       
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.booksCount
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Tipo de celda
        let cellId = "BookCell"
        
        let book = model.books[indexPath.row]
        
        
        // Crear la celda
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            // El opcional está vacío: hay que crearla a pelo.
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // Sincronizar personaje con la celda
        cell?.imageView?.image      = book.bookImage
        cell?.textLabel?.text       = book.title
        cell?.detailTextLabel?.text = book.strAuthors
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Título"
    }
    
    func listOfFavsDidChange() {
    
    }
}

extension LibraryViewControler: LibraryViewControllerDelegate{
    func libraryViewController(vc: LibraryViewControler, didSelectBook book: AGTBook){
        let bkVC = BookViewController(model: book)
        bkVC.favsDelegate = self
        //Hacerle un Push
        navigationController?.pushViewController(bkVC, animated: true)
    }
    
}

protocol LibraryViewControllerDelegate {
    
    func libraryViewController(vc: LibraryViewControler, didSelectBook book: AGTBook)
    
}
