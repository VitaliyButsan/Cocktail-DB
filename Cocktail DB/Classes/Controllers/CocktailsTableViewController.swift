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
        
    private let cocktailsViewModel = CocktailsViewModel()
    private var categoryCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNib()
        setObserver()
        cocktailsViewModel.getCategories()
        activateLoader()
    }
    
    private func activateLoader() {
        self.showIndicator(withTitle: "Loading", and: "Load categories..")
    }
    
    private func setupNib() {
        let nib = UINib(nibName: "CocktailsTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: CocktailsTableViewCell.reuseID)
    }
    
    private func setObserver() {
        cocktailsViewModel.result = { result in
            
            switch result {
            case .success( _ ):
                self.hideIndicator()
                
            case .failure(let error):
                print(error)
                /// call Alert("Error: Data not received")
            }
        }
    }
    
    private func getCocktailsList() {
        if self.categoryCounter >= self.cocktailsViewModel.cocktailsCategories.count - 1 {
            /// call Alert("no more categories")
        } else {
            let category = self.cocktailsViewModel.cocktailsCategories[self.categoryCounter]
            cocktailsViewModel.getCocktails(by: category)
            self.categoryCounter += 1
        }
    }
    
    @IBAction func filterBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showCategoriesVCSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoriesVC = segue.destination as? CategoriesFilterViewController
        categoriesVC?.categories = self.cocktailsViewModel.cocktailsCategories
    }
}

// MARK: - UITableViewController delegate

extension CocktailsTableViewController {
    
    private func setupHeaderView() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        headerView.backgroundColor = #colorLiteral(red: 0.9366536736, green: 0.9374585152, blue: 0.9576715827, alpha: 1)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Light", size: 13.0)
        label.textColor = #colorLiteral(red: 0.457996428, green: 0.4552010298, blue: 0.4835227728, alpha: 1)
        label.text = "_ _ _"
        
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
        return setupHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}

// MARK: - UITableViewController data source

extension CocktailsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CocktailsTableViewCell.reuseID, for: indexPath) as! CocktailsTableViewCell
        return cell
    }
}
