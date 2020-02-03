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
    var cocktailsTVC: CocktailsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // to hide separators of unused cells
        tableView.tableFooterView = UIView()
        
        getSavedCategories()
        makeSelected(categories ?? [])
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filterButton(isEnabled: compareNewOldSelections())
    }
    
    private func getSavedCategories() {
        savedCategories = db.getFilteredCategories()
    }
    
    private func makeSelected(_ list: [CocktailsCategory]) {
        for categoryName in list {
            categoriesForSelect.append(CategoryForSelect(name: categoryName.name, isSelect: false))
        }
    }
    
    @IBAction func applyFiltersButtonTapped(_ sender: UIButton) {
        db.deleteAllCategories()
        cocktailsTVC?.cocktailsViewModel.cocktailsListsByCategories.removeAll()
        cocktailsTVC?.categoryCounter = 0
        
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
        filterButton(isEnabled: compareNewOldSelections())
    }
    
    private func toggleCheckmarkAndCategory(at indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        if selectedCell.accessoryType == .checkmark {
            set(accessoryType: .none, to: selectedCell)
            self.categoriesForSelect[indexPath.row].isSelect = false
        } else {
            set(accessoryType: .checkmark, to: selectedCell)
            self.categoriesForSelect[indexPath.row].isSelect = true
        }
    }
    
    private func set(accessoryType: UITableViewCell.AccessoryType, to cell: UITableViewCell) {
        DispatchQueue.main.async {
            cell.accessoryType = accessoryType == .none ? .none : .checkmark
        }
    }
    
    private func compareNewOldSelections() -> Bool {
        var selectedCategories: [String] = []
        for category in categoriesForSelect {
            if category.isSelect {
                selectedCategories.append(category.name)
            }
        }
        return Set(savedCategories) == Set(selectedCategories)
    }
    
    private func filterButton(isEnabled: Bool) {
        DispatchQueue.main.async {
            self.filterButton.isEnabled = isEnabled ? false : true
            self.filterButton.layer.borderColor = isEnabled ? UIColor.lightGray.cgColor : UIColor.black.cgColor
        }
    }
}

// MARK: - Table view data source

extension CategoriesFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.reuseID, for: indexPath) as! CategoriesTableViewCell
    
        cell.textLabel?.text = categories?[indexPath.row].name
        cell.indentationWidth = 10
        cell.selectionStyle = .none
        
        addCheckmarks(to: cell, by: indexPath)
        return cell
    }
    
    private func addCheckmarks(to cell: CategoriesTableViewCell, by indexPath: IndexPath) {
        guard let categories = categories else { return }
        if savedCategories.contains(categories[indexPath.row].name) {
            cell.accessoryType = .checkmark
            categoriesForSelect[indexPath.row].isSelect = true
        }
    }
}
