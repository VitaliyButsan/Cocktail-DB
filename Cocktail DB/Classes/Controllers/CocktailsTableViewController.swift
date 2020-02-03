//
//  ViewController.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import MBProgressHUD

class CocktailsTableViewController: UITableViewController {
        
    private struct Constants {
        static let nibName: String = "CocktailsTableViewCell"
        static let segueIdentifier: String = "showCategoriesVCSegue"
        static let headerViewFontName: String = "Avenir-Light"
        static let headerViewFontSize: CGFloat = 13.0
        static let headerViewHieght: CGFloat = 30.0
        static let headerViewLabelHeight: CGFloat = 20.0
        static let headerViewLabelLeadingIndent: CGFloat = 16.0
        static let headerViewSeparatorHeight: CGFloat = 1.0
        static let rowHeight: CGFloat = 88.0
        static let headerHeight: CGFloat = 30.0
    }
    
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    
    let cocktailsViewModel = CocktailsViewModel()
    let db = Storage.shared
    private var isPaging = false
    var categoryCounter = 0
    var filteredCategories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNib()
        setObserver()
        cocktailsViewModel.getCategories()
        activateLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filteredCategories = db.getFilteredCategories()
        getCocktailsList()
        tableView.reloadData()
        filterBarButton.tintColor = filteredCategories.isEmpty ? .black : .red
    }
    
    private func activateLoader() {
        showIndicator(withTitle: "Loading", and: "Load categories..")
    }
    
    private func setupNib() {
        let nib = UINib(nibName: Constants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CocktailsTableViewCell.reuseID)
    }
    
    private func setObserver() {
        cocktailsViewModel.result = { result in
            switch result {
            case .success( _ ):
                self.isPaging = false
                DispatchQueue.main.async {
                    self.hideIndicator()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.hideIndicator()
                    self.alertHandler(title: "Error!", massage: "Data not received", titleForActionButton: "Try again")
                }
            }
        }
    }
    
    func getCocktailsList() {
        if !filteredCategories.isEmpty, categoryCounter <= filteredCategories.count - 1 {
            let category = CocktailsCategory(name: filteredCategories[categoryCounter])
            cocktailsViewModel.getCocktails(by: category)
            categoryCounter += 1
        }
    }
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoriesVC = segue.destination as? CategoriesFilterViewController
        categoriesVC?.categories = cocktailsViewModel.cocktailsCategories
        categoriesVC?.cocktailsTVC = self
        
    }
    
    func alertHandler(title: String, massage: String, titleForActionButton titleOfButton: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert )
        let alertAction = UIAlertAction(title: titleOfButton, style: .default) { _ in
            self.showIndicator(withTitle: "Loading", and: "Load categories..")
            self.cocktailsViewModel.getCategories()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewController delegate

extension CocktailsTableViewController {
    
    private func setupHeaderView(for section: Int) -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: Constants.headerHeight))
        headerView.backgroundColor = #colorLiteral(red: 0.9366536736, green: 0.9374585152, blue: 0.9576715827, alpha: 1)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.headerViewFontName, size: Constants.headerViewFontSize)
        label.textColor = #colorLiteral(red: 0.457996428, green: 0.4552010298, blue: 0.4835227728, alpha: 1)
        label.text = filteredCategories[section].uppercased()
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: Constants.headerViewLabelHeight),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.headerViewLabelLeadingIndent),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        let separator = UIView()
        separator.backgroundColor = #colorLiteral(red: 0.8583082557, green: 0.855119884, blue: 0.8711912036, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: Constants.headerViewSeparatorHeight),
            separator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
            
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeaderView(for: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {return}
        makePagination(by: tableView)
    }
    
    private func makePagination(by tableView: UITableView) {
        guard let visibleSection = tableView.indexPathsForVisibleRows?.first?.section else { return }
        let visibleCategory = CocktailsCategory(name: filteredCategories[visibleSection])
        guard let visibleCocktailsList = cocktailsViewModel.cocktailsListsByCategories[visibleCategory] else { return }
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        let visibleRowsIndices: [Int] = visibleIndexPaths.map { $0.row }
        
        if !isPaging,
           visibleSection == cocktailsViewModel.cocktailsListsByCategories.count - 1,
           visibleSection != filteredCategories.count - 1,
           visibleRowsIndices.contains(visibleCocktailsList.count / 2) {
                isPaging = true
                getCocktailsList()
        }
    }
}

// MARK: - UITableViewController data source

extension CocktailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = CocktailsCategory(name: filteredCategories[section])
        return cocktailsViewModel.cocktailsListsByCategories[category]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CocktailsTableViewCell.reuseID, for: indexPath) as! CocktailsTableViewCell
        let category = CocktailsCategory(name: filteredCategories[indexPath.section])
        
        if let cocktailsList = cocktailsViewModel.cocktailsListsByCategories[category] {
            cell.updateCell(by: cocktailsList[indexPath.row])
        }
        
        return cell
    }
}
