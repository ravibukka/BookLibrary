//
//  Model.swift
//  Library
//

import Foundation

import UIKit

struct BooksInformation: Decodable {
    var list: [BookDetails]
}

struct BookCategories: Decodable {
    static func fetchBookDetails(_ completionHandler: @escaping (BooksInformation) -> ()) {
        URLSession.shared.dataTask(with: URL(string: Constants.bookListUrl.rawValue)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            if let error = error {
                print(error)
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let booksInformation = try decoder.decode(BooksInformation.self, from: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(booksInformation)
                })
                
            } catch let err {
                print(err)
                self.showAlert(message: err.localizedDescription)
            }
        }) .resume()
    }
    
    static func showAlert(message: String) {
        let controller = UIApplication.shared.keyWindow?.rootViewController as? InitialViewController
        let alert = UIAlertController(title: "OoOops!", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "I will try later!", style: .cancel) { (_) in }
        alert.addAction(alertAction)
        controller?.present(alert, animated: true, completion: nil)
    }
}

struct BookDetails: Decodable {
    var id: String?
    var book_title: String?
    var author_name: String?
    var genre: String?
    var publisher: String?
    var author_country: String?
    var sold_count: Int?
    var image_url: String?
}
