//
//  Storage.swift
//  Cocktail DB
//
//  Created by Vitaliy on 29.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

final class Storage {

    private struct Constants {
        static let categories: String = "categoriesStorage"
        static let categoriesWithDrinks: String = "categoriesWithDrinksStorage"
    }
    
    static let shared = Storage()
    private init() { }
    
    // check Categories existence
    func categoriesIsExist() -> Bool {
        if UserDefaults.standard.array(forKey: Constants.categories) != nil {
            return true
        } else {
            return false
        }
    }
    
    // check categoriesWithDrinks existence
    func categoriesWithDrinksIsExist() -> Bool {
        if UserDefaults.standard.array(forKey: Constants.categoriesWithDrinks) != nil {
            return true
        } else {
            return false
        }
    }
    
    // save Categories
    func saveCategory(name: String) {
        var savedCategories = self.getFilteredCategories()

        if !savedCategories.contains(name) {
            savedCategories.append(name)
            UserDefaults.standard.set(savedCategories, forKey: Constants.categories)
        }
    }
    
    // get Categories
    func getFilteredCategories() -> [String] {
        if categoriesIsExist() {
            return UserDefaults.standard.array(forKey: Constants.categories) as! [String]
        } else {
            return []
        }
    }
    
    // delete Category
    func deleteCategory(name: String) {
        var filteredCategories = self.getFilteredCategories()

        if filteredCategories.contains(name) {
            guard let indexOfDeletingItem = filteredCategories.firstIndex(of: name) else {return}
            filteredCategories.remove(at: indexOfDeletingItem)
            UserDefaults.standard.set(filteredCategories, forKey: Constants.categories)
        }
    }
    
    // delete All Categories
    func deleteAllCategories() {
        UserDefaults.standard.removeObject(forKey: Constants.categories)
    }
}
