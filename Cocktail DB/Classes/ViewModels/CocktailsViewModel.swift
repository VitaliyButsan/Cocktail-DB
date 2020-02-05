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
    
    // MARK: - JSON Decoder
    
    private func getDecodedType<T: Decodable>(from data: Data) -> T? {
        do {
            let decodedGeneric = try JSONDecoder().decode(T.self, from: data)
            return decodedGeneric
        } catch {
            print(error)
            return nil
        }
    }

    // MARK: - Get Categories
    
    func getCategories() {
        provider.request(.getCategories) { result in
            
            switch result {
            case .success(let moyaResponse):
                guard let categoriesWrapper: CocktailsCategoriesWrapper = self.getDecodedType(from: moyaResponse.data) else { return }
                self.cocktailsCategories = categoriesWrapper.drinks
                self.result?(.success(Void()))
                
            case .failure(let error):
                print(error)
                self.result?(.failure(error))
            }
        }
    }
    
    // MARK: - Get Cocktails List by Category
    
    func getCocktails(by category: CocktailsCategory) {
        provider.request(.filter(by: category.name)) { result in
            
            switch result {
            case .success(let moyaResponse):
                guard let cocktailsWrapper: CocktailsListWrapper = self.getDecodedType(from: moyaResponse.data) else { return }
                self.cocktailsListsByCategories[category] = cocktailsWrapper.drinks
                self.result?(.success(Void()))
                
            case .failure(let error):
                print(error)
                self.result?(.failure(error))
            }
        }
    }
}
