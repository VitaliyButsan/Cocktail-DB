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
        return UserDefaults.standard.array(forKey: Constants.categories) != nil ? true : false
    }
    
    // check categoriesWithDrinks existence
    func categoriesWithDrinksIsExist() -> Bool {
        return UserDefaults.standard.array(forKey: Constants.categoriesWithDrinks) != nil ? true : false
    }
    
    // get Categories
    func getFilteredCategories() -> [String] {
        return categoriesIsExist() ? UserDefaults.standard.array(forKey: Constants.categories) as! [String] : []
    }
    
    // save Categories
    func saveCategory(name: String) {
        var savedCategories = self.getFilteredCategories()

        if !savedCategories.contains(name) {
            savedCategories.append(name)
            UserDefaults.standard.set(savedCategories, forKey: Constants.categories)
        }
    }
   
    // delete All Categories
    func deleteAllCategories() {
        UserDefaults.standard.removeObject(forKey: Constants.categories)
    }
}
