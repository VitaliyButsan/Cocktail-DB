//
//  CocktailsTableViewCell.swift
//  Cocktail DB
//
//  Created by Vitaliy on 28.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import SDWebImage

class CocktailsTableViewCell: UITableViewCell {

    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    static let reuseID: String = "CocktailsCell"
    
    func updateCell(by cocktailInfo: CocktailInfo) {
        cocktailNameLabel.text = cocktailInfo.name
        guard let imageLink = cocktailInfo.thumbLink else { return }
        cocktailImageView.sd_setImage(with: URL(string: imageLink), completed: nil)
    }
}
