//
//  ShoppingListViewModel.swift
//  ShoppingList
//
//  Created by Samira Marassy on 25/04/2024.
//

import Foundation
class ShoppingListViewModel: ObservableObject {
    @Published var newItemToBeAdded: ShoppingItem = ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    @Published var notBoughtShoppingListItems: [ShoppingItem] = []
    @Published var boughtShoppingListItems: [ShoppingItem] = []
    
    func addNewItem() {
        guard !newItemToBeAdded.isEmpty else { return }
        if newItemToBeAdded.isOn {
            boughtShoppingListItems.append(newItemToBeAdded)
        } else {
            notBoughtShoppingListItems.append(newItemToBeAdded)
        }
        self.newItemToBeAdded = emptyShoppingItem()
    }
    
    func emptyShoppingItem() -> ShoppingItem {
        ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    }
}
