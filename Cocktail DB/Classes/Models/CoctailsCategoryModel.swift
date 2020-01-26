//
//  CoctailsListModel.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

struct CocktailsCategoriesWrapper: Decodable {
    let drinks: [CocktailsCategory]
}

struct CocktailsCategory: Decodable {
    let strCategory: String
}
