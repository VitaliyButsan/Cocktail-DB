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
        
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    
    private let cocktailsViewModel = CocktailsViewModel()
    private let db = Storage.shared
    private var isPaging = false
    private var categoryCounter = 0
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNib()
        setObserver()
        cocktailsViewModel.getCategories()
        activateLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = db.getCategories()
        getCocktailsList()
        categoryCounter = 0
        tableView.reloadData()
    }
    
    private func activateLoader() {
        showIndicator(withTitle: "Loading", and: "Load categories..")
    }
    
    private func setupNib() {
        let nib = UINib(nibName: "CocktailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CocktailsTableViewCell.reuseID)
    }
    
    private func setObserver() {
        cocktailsViewModel.result = { result in
            switch result {
            case .success( _ ):
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
    
    private func getCocktailsList() {
        if !categories.isEmpty {
            if categoryCounter > categories.count - 1 {
                /// call Alert("no more categories")
            } else {
                let category = CocktailsCategory(strCategory: categories[categoryCounter])
                cocktailsViewModel.getCocktails(by: category)
                categoryCounter += 1
            }
        }
    }
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showCategoriesVCSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoriesVC = segue.destination as? CategoriesFilterViewController
        categoriesVC?.categories = cocktailsViewModel.cocktailsCategories
    }
    
    func alertHandler(title: String, massage: String, titleForActionButton titleOfButton: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert )
        let alertAction = UIAlertAction(title: titleOfButton, style: .default) { [unowned self] _ in
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
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        headerView.backgroundColor = #colorLiteral(red: 0.9366536736, green: 0.9374585152, blue: 0.9576715827, alpha: 1)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Light", size: 13.0)
        label.textColor = #colorLiteral(red: 0.457996428, green: 0.4552010298, blue: 0.4835227728, alpha: 1)
        label.text = categories[section].uppercased()
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20.0),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        let separator = UIView()
        separator.backgroundColor = #colorLiteral(red: 0.8583082557, green: 0.855119884, blue: 0.8711912036, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1.0),
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
        return 88.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {return}
        guard let visibleSection = tableView.indexPathsForVisibleRows?.first?.section else { return }
        let category = CocktailsCategory(strCategory: categories[visibleSection])
        guard let cocktailsList = cocktailsViewModel.cocktailsListsByCategories[category] else { return }
            
        // pagination
        if tableView.indexPathsForVisibleRows?.last?.row == cocktailsList.count / 2 {
            if !isPaging {
                //getCocktailsList()
                isPaging = true
            }
        }
    }
}

// MARK: - UITableViewController data source

extension CocktailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = CocktailsCategory(strCategory: categories[section])
        return cocktailsViewModel.cocktailsListsByCategories[category]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CocktailsTableViewCell.reuseID, for: indexPath) as! CocktailsTableViewCell
        let category = CocktailsCategory(strCategory: categories[indexPath.section])
        
        if let cocktailsList = cocktailsViewModel.cocktailsListsByCategories[category] {
            cell.updateCell(by: cocktailsList[indexPath.row])
        }
        
        return cell
    }
}
