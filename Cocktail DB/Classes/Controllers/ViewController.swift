//
//  ViewController.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cocktailsModel = CocktailsViewModel()
    private var categoryCounter: Int = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        getCocktailsList(by: self.cocktailsModel.cocktailsCategories.first ?? nil)
    }

    private func getCocktailsList(by category: CocktailsCategory?) {
        
        if category == nil {
            cocktailsModel.getCategories { [unowned self] result in
                if result != nil {
                    self.categoryCounter += 1
                    let firstCategory = self.cocktailsModel.cocktailsCategories[self.categoryCounter]
                    
                    self.cocktailsModel.getCocktailsList(by: firstCategory) { result in
                        guard let cocktailsInfo = result else { return }
                        for cocktail in cocktailsInfo {
                            print("cockt_info < 1:", cocktail.name ?? "...")
                        }
                    }
                    
                } else {
                    print("ERROR: No categories!")
                    // Show Alert
                }
            }
            
        } else {
            self.cocktailsModel.getCocktailsList(by: category!) { result in
                guard let cocktailsInfo = result else { return }
                self.categoryCounter += 1
                
                for cocktail in cocktailsInfo {
                    print("cockt_info > 1:", cocktail.name ?? "...")
                }
            }
        }
    }
}

