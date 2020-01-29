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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.savedCategories = self.db.getCategories()
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
        toggleCheckmark(at: indexPath)
        saveSelectedCategory(at: indexPath)
        compareNewOldSelections()
    }
    
    private func toggleCheckmark(at indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = selectedCell?.accessoryType == .checkmark ? .none : .checkmark
    }
    
    private func saveSelectedCategory(at indexPath: IndexPath) {
        guard let selectedCategoryName = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        
        if categoriesForSelect.contains(where: { $0.name == selectedCategoryName}) {
            if let index = self.categoriesForSelect.firstIndex(where: {$0.name == selectedCategoryName}) {
                self.categoriesForSelect[index].isSelect.toggle()
            }
        } else {
            categoriesForSelect.append(CategoryForSelect(name: selectedCategoryName, isSelect: true))
        }
    }
    
    private func compareNewOldSelections() {
        if !savedCategories.isEmpty {
            if isEquals(savedCategories, categoriesForSelect) {
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
    }
    
    private func isEquals(_ list1: [String], _ list2: [CategoryForSelect]) -> Bool {
        var tempArray: [String] = []
        for category in list2 {
            if category.isSelect {
                tempArray.append(category.name)
            }
        }
        return Set(list1) == Set(tempArray)
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
        
        cell.indentationWidth = 10
        cell.selectionStyle = .none
        return cell
    }
}
