//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Iberfan on 16/7/16.
//  Copyright © 2016 AlmaMartinez. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UISplitViewControllerDelegate {

    //MARK: - Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthors: UILabel!
    @IBOutlet weak var esFavorito: UISwitch!
    @IBOutlet weak var lbTags: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    var model : AGTBook
    var favsDelegate: ListOfFavoritesChangedDelegate?
    var masterPopoverController: UIPopoverController? = nil

    //MARK: - Inits
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: AGTBook){
        self.model = model
        self.favsDelegate = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    func syncModelWithView()  {
        self.title = self.model.title
        imgCover.image = self.model.bookImage
        
        lbTitle.text = self.model.title
        
        lbAuthors.text = self.model.strAuthors
        
        lbTags.text = self.model.strTags

        esFavorito.setOn(self.model.isFavourite, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = .None
        syncModelWithView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchLeerLibro(sender: UIButton) {
        let pdfVC = PdfViewController(model: self.model)
        navigationController?.pushViewController(pdfVC, animated: true)
    }

    @IBAction func changeFavorito(sender: UISwitch) {
        self.model.changeFavorite()
        if favsDelegate != nil{
            favsDelegate?.listOfFavsDidChange()
        }
        
    }
    
    //MARK: - SplitViewControllerDelegate:
    func splitViewController(splitController: UISplitViewController, willHideViewController viewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController popoverController: UIPopoverController) {
        barButtonItem.title = "Listado"
        self.navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
        self.masterPopoverController = popoverController
    }
    
    func splitViewController(splitController: UISplitViewController, willShowViewController viewController: UIViewController, invalidatingBarButtonItem barButtonItem: UIBarButtonItem) {
        // Called when the view is shown again in the split view, invalidating the button and popover controller.
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        self.masterPopoverController = nil
    }
}

extension BookViewController: LibraryViewControllerDelegate{
    func libraryViewController(vc: LibraryViewControler, didSelectBook book: AGTBook){
        model = book
        syncModelWithView()
    }
}
