//
//  TagLibraryViewController.swift
//  HackerBooks
//
//  Created by Iberfan on 16/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import UIKit

class TagLibraryViewController: LibraryViewControler{
    
    
    
        
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Libros por Tag"
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(reloadFavorites), name: ListOfFavsDidChangeNotification, object: nil)
    }
    
    
    @objc
    override func reloadCell(notif : NSNotification){
        if let book = notif.userInfo?[BookKey] as? AGTBook{
            for tag in book.tags{
                if let tagIdx = model.indexForTag(tag),
                bkIdx = model.indexForBook(book, atTag: tag){
                    let indexPath = NSIndexPath(forItem: bkIdx, inSection: tagIdx)
                    let visibleIndexPaths = tableView.indexPathsForVisibleRows
                    if ((visibleIndexPaths?.contains(indexPath)) != nil){
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                }
            }
        }        
    }
    
    func reloadFavorites(notif: NSNotification){
        listOfFavsDidChange()
    }
    
    override func listOfFavsDidChange() {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Averiguar cual es el libro
        if let book = model.bookAtIndex(indexPath.row, forTag: model.tagForIndex(indexPath.section)){
            
            // Avisar al delegado
            delegate?.libraryViewController(self, didSelectBook: book)
           
            
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.tags.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.bookCountForTag(model.tagForIndex(section))
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Tipo de celda
        let cellId = "BookCell"
        
        // Crear la celda
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            // El opcional está vacío: hay que crearla a pelo.
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }

        if let book = model.bookAtIndex(indexPath.row, forTag: model.tagForIndex(indexPath.section)){
            // Sincronizar personaje con la celda
            cell?.imageView?.image      = book.bookImage
            cell?.textLabel?.text       = book.title
            cell?.detailTextLabel?.text = book.strAuthors
        
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.tagForIndex(section).name
    }
    
    
}

protocol ListOfFavoritesChangedDelegate{
    func listOfFavsDidChange()
}


