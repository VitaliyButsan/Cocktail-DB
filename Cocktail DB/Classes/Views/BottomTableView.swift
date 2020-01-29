//
//  BottomTableView.swift
//  Cocktail DB
//
//  Created by Vitaliy on 28.01.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class BottomTableView: UIView {

    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("BottomButton", for: .normal)
        return button
    }()
    
    convenience override init(frame: CGRect) {
        self.init(frame: CGRect.zero)
        //setupFilterButton()
    }
    
    private func setupFilterButton() {
        self.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.heightAnchor.constraint(equalToConstant: 30),
            filterButton.widthAnchor.constraint(equalToConstant: 100),
            filterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        ])
    }
}
