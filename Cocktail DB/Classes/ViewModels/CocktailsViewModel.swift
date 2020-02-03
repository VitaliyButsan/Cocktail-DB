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
    var cocktailsListsByCategories: [CocktailsCategory : [CocktailInfo]] = [:]
    var result: ((Result<Void, Error>) -> Void)?
    
    // MARK: - Get Categories
    
    func getCategories() {
        
        provider.request(.getCategories) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moyaResponse):
                guard let receivedCategories = self.getCocktailsCategories(from: moyaResponse.data) else { return }
                self.cocktailsCategories = receivedCategories
                self.result?(.success(Void()))
                
            case .failure(let error):
                print(error)
                self.result?(.failure(error))
            }
        }
    }
    
    private func getCocktailsCategories(from data: Data) -> [CocktailsCategory]? {
        do {
            let cocktailsWrapper = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
            return cocktailsWrapper.drinks
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - Get Cocktails List by Category
    
    func getCocktails(by category: CocktailsCategory) {
        
        provider.request(.filter(by: category.name)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moyaResponse):
                guard let receivedCocktails = self.getCocktailsList(from: moyaResponse.data) else { return }
                self.cocktailsListsByCategories[category] = receivedCocktails
                self.result?(.success(Void()))
                
            case .failure(let error):
                print(error)
                self.result?(.failure(error))
            }
        }
    }
    
    private func getCocktailsList(from data: Data) -> [CocktailInfo]? {
        do {
            let coctailsWrapper = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
            return coctailsWrapper.drinks
        } catch {
            print(error)
            return nil
        }
    }
}
