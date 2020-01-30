//
//  FilterCategoriesTableViewController.swift
//  Cocktail DB
//
//  Created by Vitaliy on 28.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class CategoriesFilterViewController: UIViewController {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let db = Storage.shared
    private var savedCategories: [String] = []
    private var categoriesForSelect: [CategoryForSelect] = []
    var categories: [CocktailsCategory]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // to hide separators of unused cells
        tableView.tableFooterView = UIView()
        
        getSavedCategories()
        makeSelected(categories ?? [])
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        compareNewOldSelections()
    }
    
    private func getSavedCategories() {
        savedCategories = db.getCategories()
    }
    
    private func makeSelected(_ list: [CocktailsCategory]) {
        for categoryName in list {
            categoriesForSelect.append(CategoryForSelect(name: categoryName.strCategory, isSelect: false))
        }
    }
    
    @IBAction func applyFiltersButtonTapped(_ sender: UIButton) {
        db.deleteAllCategories()
        
        for category in categoriesForSelect {
            if category.isSelect {
                db.saveCategory(name: category.name)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

    // MARK: - Table view delegate

extension CategoriesFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleCheckmarkAndCategory(at: indexPath)
        compareNewOldSelections()
    }
    
    private func toggleCheckmarkAndCategory(at indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        if selectedCell.accessoryType == .checkmark {
            selectedCell.accessoryType = .none
            self.categoriesForSelect[indexPath.row].isSelect = false
        } else {
            selectedCell.accessoryType = .checkmark
            self.categoriesForSelect[indexPath.row].isSelect = true
        }
    }
    
    private func compareNewOldSelections() {
        if isEquals(savedCategories, with: categoriesForSelect) {
            DispatchQueue.main.async {
                self.filterButton.isEnabled = false
                self.filterButton.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            }
        } else {
            DispatchQueue.main.async {
                self.filterButton.isEnabled = true
                self.filterButton.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    private func isEquals(_ compare: [String], with compared: [CategoryForSelect]) -> Bool {
        var tempCompared: [String] = []
        for category in compared {
            if category.isSelect {
                tempCompared.append(category.name)
            }
        }
        return Set(compare) == Set(tempCompared)
    }
}

// MARK: - Table view data source

extension CategoriesFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.reuseID, for: indexPath) as! CategoriesTableViewCell
        let cocktailsCategory = categories?[indexPath.row]
        
        cell.textLabel?.text = cocktailsCategory?.strCategory
    
        addCheckmarks(to: cell, by: indexPath)
        cell.indentationWidth = 10
        cell.selectionStyle = .none
        return cell
    }
    
    private func addCheckmarks(to cell: CategoriesTableViewCell, by indexPath: IndexPath) {
        guard let categories = categories else { return }
        if savedCategories.contains(categories[indexPath.row].strCategory) {
            cell.accessoryType = .checkmark
            categoriesForSelect[indexPath.row].isSelect = true
        }
    }
}
