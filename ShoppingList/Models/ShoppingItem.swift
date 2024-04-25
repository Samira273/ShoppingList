//
//  ShoppingItem.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import Foundation

struct ShoppingItem {
    var name: String
    var quantity: String
    var description: String
    var isOn: Bool
    
    var isEmpty: Bool {
         name.isEmpty && quantity.isEmpty
    }
}
