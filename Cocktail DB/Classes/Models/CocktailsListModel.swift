//
//  CocktailsListModel.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

struct CocktailsListWrapper: Decodable {
    let drinks: [CocktailInfo]
}

struct CocktailInfo: Decodable {
    let name: String?
    let thumbLink: String?
    let idDrink: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbLink = "strDrinkThumb"
        case idDrink
    }
}
