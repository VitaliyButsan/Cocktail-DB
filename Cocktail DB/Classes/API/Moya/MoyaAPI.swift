//
//  MoyaAPI.swift
//  Cocktail DB
//
//  Created by Vitaliy on 26.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation
import Moya

enum CocktailDB {
    case getCategories
    case filter(by: String)
}

// MARK: - TargetType Protocol Implementation

extension CocktailDB: TargetType {
    
    var baseURL: URL { return URL(string: "https://www.thecocktaildb.com/api/json/v1/1")! }
    
    var path: String {
        switch self {
        case .getCategories:
            return "/list.php"
        case .filter:
            return "/filter.php"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategories, .filter:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getCategories:
            return .requestParameters(parameters: ["c" : "list"], encoding: URLEncoding.default)
        case .filter(let category):
            return .requestParameters(parameters: ["c" : "\(category)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
