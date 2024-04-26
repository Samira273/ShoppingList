//
//  ShoppingListViewModel.swift
//  ShoppingList
//
//  Created by Samira Marassy on 25/04/2024.
//

import Foundation
import Combine

class ShoppingListViewModel: ObservableObject {
    
    @Published var newItemToBeAdded: ShoppingItem = ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    @Published var itemToBeEdited: ShoppingItem = ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    @Published var shoppingListItemsToDisplay: [ShoppingItem] = []
    @Published var shoppingListState: ShoppingListState = .notBought
    @Published var searchText: String = ""
    var noItemsToDisplay: Bool {
        notBoughtShoppingListItems.isEmpty && boughtShoppingListItems.isEmpty
    }

    
    // MARK: - Private Variables
    @Published private var notBoughtShoppingListItems: [ShoppingItem] = []
    @Published private var boughtShoppingListItems: [ShoppingItem] = []
    private var listStatePublisher: AnyPublisher<ShoppingListState, Never> {
        $shoppingListState.eraseToAnyPublisher()
    }
    private var searchTextPublisher: AnyPublisher<String, Never> {
        $searchText.eraseToAnyPublisher()
    }

    private var cancellable = Set<AnyCancellable>()


    func addNewItem() {
        guard !newItemToBeAdded.isEmpty else { return }
        switch shoppingListState {
        case .bought:
            boughtShoppingListItems.append(newItemToBeAdded)
        case .notBought:
            notBoughtShoppingListItems.append(newItemToBeAdded)
        }
        updateState()
        self.newItemToBeAdded = emptyShoppingItem()
    }
    
    init() {
        setupPublishers()
    }
    
    func emptyShoppingItem() -> ShoppingItem {
        ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    }
    
    func willEdit(item: ShoppingItem) {
       itemToBeEdited = item
    }
    
    func deleteItem(at offsets: IndexSet) {
        switch shoppingListState {
        case .bought:
            boughtShoppingListItems.remove(atOffsets: offsets)
        case .notBought:
            notBoughtShoppingListItems.remove(atOffsets: offsets)
        }
        updateState()
    }
    
    func isBoughtToggled(for item: ShoppingItem) {
        var item = item
        switch item.isOn {
        case true: //it is in bought list
            guard let index = boughtShoppingListItems.firstIndex(where: {$0.id == item.id}) else { return }
            item.isOn.toggle()
            notBoughtShoppingListItems.append(item)
            boughtShoppingListItems.remove(at: index)
    
        case false: // it is in not Bought list
            guard let index = notBoughtShoppingListItems.firstIndex(where: {$0.id == item.id}) else { return }
            item.isOn.toggle()
            boughtShoppingListItems.append(item)
            notBoughtShoppingListItems.remove(at: index)
        }
        updateState()
    }
    
    private func updateState(_ state: ShoppingListState? = nil) {
        shoppingListState = state ?? shoppingListState
    }
    
    func endEditing() {
        switch itemToBeEdited.isOn {
        case true:
            guard let index = boughtShoppingListItems.firstIndex(where: {$0.id == itemToBeEdited.id}) else { return }
            boughtShoppingListItems[index] = itemToBeEdited
        case false:
            guard let index = notBoughtShoppingListItems.firstIndex(where: {$0.id == itemToBeEdited.id}) else { return }
            notBoughtShoppingListItems[index] = itemToBeEdited
        }
        updateState()
    }
    
    private func searchItems(searchText: String) {
        let list: [ShoppingItem]
        switch shoppingListState {
        case .bought:
            list = boughtShoppingListItems
        case .notBought:
            list = notBoughtShoppingListItems
        }
        if searchText.isEmpty {
            shoppingListItemsToDisplay = list
            return
        }
        let searchResultList = list.filter({$0.description.contains(searchText) || $0.name.contains(searchText)})
        shoppingListItemsToDisplay = searchResultList
    }
    
    private func setupPublishers() {

        listStatePublisher
            .sink { [weak self] newValue in
                guard let self else { return }
                switch newValue {
                case .bought:
                    shoppingListItemsToDisplay = boughtShoppingListItems
                case .notBought:
                    shoppingListItemsToDisplay = notBoughtShoppingListItems
                }
            }
            .store(in: &cancellable)
        
        searchTextPublisher
        //    .debounce(for: .milliseconds(800), scheduler: RunLoop.main) this if we will search remotly on server
            .removeDuplicates()
            .map({ (string) -> String? in
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in } receiveValue: { [self] (searchField) in
                searchItems(searchText: searchField)
            }.store(in: &cancellable)
    }
}

enum ShoppingListState {
    case bought
    case notBought
}
