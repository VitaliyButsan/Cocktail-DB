//
//  ViewController.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let cocktailsViewModel = CocktailsViewModel()
    private var categoryCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        cocktailsViewModel.getCategories()
        setObserver()
    }
    
    private func setObserver() {
        cocktailsViewModel.result = { result in
            
            switch result {
            case .success( _ ):
                if self.cocktailsViewModel.cocktailsListsByCategories.isEmpty {
                    self.getCocktailsList()
                } else {
                    // reloadData()
                }
                
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
}

