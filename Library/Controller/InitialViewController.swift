//
//  ViewController.swift
//  Library
//

import UIKit

class InitialViewController: UIViewController {

    var bookList: [BookDetails] = []
    @IBOutlet weak var createButton: UIButtonActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func createAction(_ sender: Any) {
        createButton.showLoading()
        BookCategories.fetchBookDetails { (bookDetails) -> () in
            self.createButton.hideLoading()
            self.bookList = bookDetails.list
            self.performSegue(withIdentifier: Constants.bookListSegue.rawValue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.bookListSegue.rawValue {
            if let destination = segue.destination as? BookListViewController {
                destination.bookList = bookList
            }
        }
    }
}

