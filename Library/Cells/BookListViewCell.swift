//
//  BookListViewCell.swift
//  Library
//

import UIKit

class BookListViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var soldCountLabel: UILabel!
    @IBOutlet weak var bookMarkButton: UIButton!
    
    var bookMarkClosure: ((_ isSelected: Bool) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpInterface()
    }

    func setupData(bookDetails: BookDetails) {
        bookImageView.loadImageWith(urlString: bookDetails.image_url ?? "")
        bookTitleLabel.text = bookDetails.book_title ?? ""
        authorLabel.text = bookDetails.author_name ?? ""
        genreLabel.text = bookDetails.genre ?? ""
        publisherLabel.text = bookDetails.publisher ?? ""
        soldCountLabel.text = "\(bookDetails.sold_count ?? 0) " + (bookDetails.sold_count ?? 0 > 1 ? "Copies Sold" : "Copy Sold")
    }
    
    func setUpInterface() {
        bookImageView.layer.masksToBounds = true
        bookImageView.layer.shadowColor = UIColor.black.cgColor
        bookImageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        miniView.layer.masksToBounds = true
        miniView.layer.shadowColor = UIColor.black.cgColor
        miniView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    }
    
    @IBAction func bookMarkButtonTapped(_ sender: Any) {
        if let closure = bookMarkClosure {
            bookMarkButton.isSelected = !bookMarkButton.isSelected
            closure(bookMarkButton.isSelected)
        }
    }
}
