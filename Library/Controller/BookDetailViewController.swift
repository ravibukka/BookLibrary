//
//  BookDetailViewController.swift
//  Library
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    var bookDetails: BookDetails? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    private func setUpData() {
        if let book = bookDetails {
            title = bookDetails?.book_title
            bookCover.loadImageWith(urlString: book.image_url ?? "")
            bookAuthor.text = book.author_name ?? ""
            bookDescription.text = book.id ?? ""
            bookGenre.text = book.genre ?? ""
        }
    }
}
