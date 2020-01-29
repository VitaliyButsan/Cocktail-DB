//
//  FilterCategoriesTableViewController.swift
//  Cocktail DB
//
//  Created by Vitaliy on 28.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class CategoriesFilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categories: [CocktailsCategory]?
    var categoriesForSelect: [CategoryForSelect] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // to hide separators of unused cells
        tableView.tableFooterView = UIView()
        makeIsSelected(categories ?? [])
    }
    
    private func makeIsSelected(_ categories: [CocktailsCategory]) {
        for value in categories {
            categoriesForSelect.append(CategoryForSelect(name: value.strCategory, isSelect: false))
        }
    }
    
    @IBAction func applyFiltersButtonTapped(_ sender: UIButton) {
        print("tap tap tap")
    }
}

    // MARK: - Table view delegate

extension CategoriesFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedCell = tableView.cellForRow(at: indexPath)
         selectedCell?.accessoryType = selectedCell?.accessoryType == .checkmark ? .none : .checkmark
         
         let selectedCategoryName = selectedCell?.textLabel?.text
         
         categoriesForSelect.forEach { category in
             if category.name == selectedCategoryName {
                 if let index = self.categoriesForSelect.firstIndex(where: {$0 == category}) {
                     self.categoriesForSelect[index].isSelect.toggle()
                 }
             }
         }
     }
}

// MARK: - Table view data source

extension CategoriesFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesForSelect.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.reuseID, for: indexPath) as! CategoriesTableViewCell
        let cocktailsCategory = categoriesForSelect[indexPath.row]
        
        cell.textLabel?.text = cocktailsCategory.name
        
        cell.indentationWidth = 10
        cell.selectionStyle = .none
        
        return cell
    }
}
