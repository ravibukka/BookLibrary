//
//  BookListViewController.swift
//  Library
//
//

import UIKit

class BookListViewController: UITableViewController {
    
    enum FilterType: String {
        case Auther = "Author"
        case Country = "Country"
        case Genre = "Genre"
        case FullList = "Show Complete List"
        case Cancel = "Cancel"
    }
    
    var bookList: [BookDetails] = []
    var bookMarkedList: [BookDetails] = []

    var filterList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPullToRefresh()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Filter", style: .plain, target: self, action: #selector(filterAction))
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    fileprivate func setUpPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc fileprivate func filterAction() {
        showFirstFilterSheet()
    }
    
    @objc fileprivate func refreshData() {
        BookCategories.fetchBookDetails { (bookDetails) -> () in
            self.bookList = bookDetails.list
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func showFirstFilterSheet() {
        let actionSheet = UIAlertController.init(title: "Filter Library", message: nil, preferredStyle: .actionSheet)
        
        let authorAction = UIAlertAction(title: FilterType.Auther.rawValue, style: .default) { _ in
            self.filterList = self.bookList.map({$0.author_name ?? ""}).orderedSet
            self.showSecondFilterSheet(type: .Auther)
        }
        
        let CountryAction = UIAlertAction(title: FilterType.Country.rawValue, style: .default) { _ in
            self.filterList = self.bookList.map({$0.author_country ?? ""}).orderedSet
            self.showSecondFilterSheet(type: .Country)
        }
        
        let GenreAction = UIAlertAction(title: FilterType.Genre.rawValue, style: .default) { _ in
            self.filterList = self.bookList.map({$0.genre ?? ""}).orderedSet
            self.showSecondFilterSheet(type: .Genre)
        }
        
        let showAll = UIAlertAction(title: FilterType.FullList.rawValue, style: .default) { _ in
            self.refreshData()
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: FilterType.Cancel.rawValue, style: .destructive) { _ in
            self.tableView.reloadData()
        }
        
        actionSheet.addAction(authorAction)
        actionSheet.addAction(CountryAction)
        actionSheet.addAction(GenreAction)
        actionSheet.addAction(showAll)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func showSecondFilterSheet(type: FilterType) {
        let actionSheet = UIAlertController.init(title: "Filter Library for \(type.rawValue)", message: nil, preferredStyle: .actionSheet)
        for element in filterList {
            let action = UIAlertAction(title: element, style: .default) { _ in
                self.handleActionSheetAction(element: element, type: type)
            }
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: FilterType.Cancel.rawValue, style: .destructive) { _ in
            self.tableView.reloadData()
        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func handleActionSheetAction(element: String, type: FilterType) {
        switch type {
        case .Auther:
            bookList = bookList.filter({return $0.author_name == element})
            tableView.reloadData()
        case .Country:
            bookList = bookList.filter({return $0.author_country == element})
            tableView.reloadData()
        case .Genre: bookList =
            bookList.filter({return $0.genre == element})
        tableView.reloadData()
        case .FullList: break
        case .Cancel: break
        }
        
        BookCategories.fetchBookDetails { (bookDetails) -> () in
            self.bookList = bookDetails.list
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookListCell.rawValue,
                                                       for: indexPath) as? BookListViewCell else { return UITableViewCell() }
        cell.setupData(bookDetails: bookList[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.bookMarkClosure = { isSelected in
            cell.bookMarkButton.isSelected = isSelected
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.bookDetailsSegue.rawValue, sender: bookList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.bookDetailsSegue.rawValue {
            if let destination = segue.destination as? BookDetailViewController {
                destination.bookDetails = sender as? BookDetails
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.bookList.remove(at: indexPath.row)
            self.tableView.reloadData()
            success(true)
        })
        closeAction.image = UIImage(named: "Delete")?.withRenderingMode(.alwaysTemplate)
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Bookmark", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if let cell = tableView.cellForRow(at: indexPath) as? BookListViewCell {
                cell.bookMarkButton.isSelected = !cell.bookMarkButton.isSelected
                if cell.bookMarkButton.isSelected {
                    self.bookMarkedList.append(self.bookList[indexPath.row])
                } else {
                    self.bookMarkedList.remove(at: indexPath.row)
                }
            }
            success(true)
        })
        modifyAction.image = UIImage(named: "UnSelectedBM")?.withRenderingMode(.alwaysTemplate)
        modifyAction.backgroundColor = UIColor.lightGray
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
