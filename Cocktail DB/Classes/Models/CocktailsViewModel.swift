//
//  CocktailsViewModel.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Moya

class CocktailsViewModel {
    
    private let provider = MoyaProvider<CocktailDB>()
    var cocktailsCategories: [CocktailsCategory] = []
    var cocktailsList: [CocktailInfo] = []
    
    // MARK: - Get Categories
    
    func getCategories(completionHandler: @escaping ([CocktailsCategory]?) -> Void) {
        
        provider.request(.getCategories) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moyaResponse):
                guard let drinksCategories = self.getDrinksCategories(from: moyaResponse.data) else { return }
                self.cocktailsCategories = drinksCategories
                completionHandler(drinksCategories)
                
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    private func getDrinksCategories(from data: Data) -> [CocktailsCategory]? {
        do {
            let cocktailsWrapper = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
            return cocktailsWrapper.drinks
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Get Cocktails List by Category
    
    func getCocktailsList(by drinks: CocktailsCategory, completionHandler: @escaping ([CocktailInfo]?) -> Void) {
        
        provider.request(.filter(by: drinks.strCategory)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moyaResponse):
                guard let drinksList = self.getDrinksList(from: moyaResponse.data) else { return }
                completionHandler(drinksList)
                self.cocktailsList = drinksList
                
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    private func getDrinksList(from data: Data) -> [CocktailInfo]? {
        do {
            let coctailsWrapper = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
            return coctailsWrapper.drinks
        } catch {
            print(error)
            return nil
        }
    }
    
}
