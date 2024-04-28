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
    @Published var sortInputs: (method: SortingMethod, criteria: SortingCriteria) = (.ascending, .name)
    @Published var toggledItem = ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    var errorMessage = ""
    
    // MARK: - Checks
    @Published var clearSortTapped = false
    @Published var doneSortTapped = false
    @Published var doneNewItem = false
    @Published var doneEditing = false
    @Published var isSearching = false
    @Published var showValidationErrorAlert: Bool = false
    @Published var showAddItemSheet: Bool = false
    @Published var showEditItemSheet: Bool = false
    
    // MARK: - Computed Properties
    var noItemsToDisplay: Bool {
        notBoughtShoppingListItems.isEmpty && boughtShoppingListItems.isEmpty
    }
    
    // MARK: - Private Variables
    var isSorting = false
    var notBoughtShoppingListItems: [ShoppingItem] = []
    var boughtShoppingListItems: [ShoppingItem] = []
    private var listStatePublisher: AnyPublisher<ShoppingListState, Never> {
        $shoppingListState.eraseToAnyPublisher()
    }
    private var searchTextPublisher: AnyPublisher<String, Never> {
        $searchText.eraseToAnyPublisher()
    }
    private var clearSortPublisher: AnyPublisher<Bool, Never> {
        $clearSortTapped.eraseToAnyPublisher()
    }
    private var doneSortPublisher: AnyPublisher<Bool, Never> {
        $doneSortTapped.eraseToAnyPublisher()
    }
    private var doneNewItemPublisher: AnyPublisher<Bool, Never> {
        $doneNewItem.eraseToAnyPublisher()
    }
    var doneEditingPublisher: AnyPublisher<Bool, Never> {
        $doneEditing.eraseToAnyPublisher()
    }
    private var toggledItemPublisher: AnyPublisher<ShoppingItem, Never> {
        $toggledItem.eraseToAnyPublisher()
    }
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        setupPublishers()
        fetchData()
    }
    
    // MARK: - Fetch data
    func fetchData() {
        // if we have remote fetch from server of fetch data with core data.
    }
    
    //MARK: - Public Functions
    
    func createEmptyShoppingItem() -> ShoppingItem {
        ShoppingItem(name: "", quantity: "", description: "", isOn: false)
    }
    
    func addNewItem() {
        guard validateNameAndQuantity(of: newItemToBeAdded) else {
            showValidationErrorAlert.toggle()
            return
        }
        showAddItemSheet.toggle()
        notBoughtShoppingListItems.append(newItemToBeAdded)
        updateState()
        self.newItemToBeAdded = createEmptyShoppingItem()
    }
    
    
    func willEdit(item: ShoppingItem) { // here is to display the item in the AddNewItemView
        itemToBeEdited = item
    }
    
    func deleteItem(at offsets: IndexSet) {
        
        if isSorting || isSearching, let index = offsets.first { // deleting item while searching or sorting is different from normal delete while filtering with bought w not bought
            deleteItemWhenSortingOrSearching(at: index)
            return
        }
        
        switch shoppingListState { //normal delete
        case .bought:
            boughtShoppingListItems.remove(atOffsets: offsets)
        case .notBought:
            notBoughtShoppingListItems.remove(atOffsets: offsets)
        }
        updateState()
    }
    
    // MARK: - Private Functions
    
    private func deleteItemWhenSortingOrSearching(at index: Int) {
        let item = shoppingListItemsToDisplay.remove(at: index) // we first delete from the display list
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.shoppingListItemsToDisplay = self.shoppingListItemsToDisplay
        }
        switch shoppingListState { // search for the item in the current state, delete it from the according list
        case .bought:
            guard let index = boughtShoppingListItems.firstIndex(where: {$0.id == item.id}) else {return}
            boughtShoppingListItems.remove(at: index)
        case .notBought:
            guard let index = notBoughtShoppingListItems.firstIndex(where: {$0.id == item.id}) else { return }
            notBoughtShoppingListItems.remove(at: index)
        }
    }
    
    private func validateNameAndQuantity(of item: ShoppingItem) -> Bool {
        if item.isEmpty {
            errorMessage = "Please enter name and quantity."
            return false
        }
        if item.name.isEmpty {
            errorMessage = "Please enter a name."
            return false
        }
        if item.quantity.isEmpty {
            errorMessage = "Please enter a quantity."
            return false
        }
        if !(item.quantity.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) || Int(item.quantity) ?? 0 < 1 {
            errorMessage = "Please enter valid quantity."
            return false
        }
        return true
    }
    
    private func endEditing() {
        guard validateNameAndQuantity(of: itemToBeEdited) else {
            showValidationErrorAlert.toggle()
            return
        }
        switch itemToBeEdited.isOn {
        case true:
            guard let index = boughtShoppingListItems.firstIndex(where: {$0.id == itemToBeEdited.id}) else { return }
            boughtShoppingListItems[index] = itemToBeEdited
        case false:
            guard let index = notBoughtShoppingListItems.firstIndex(where: {$0.id == itemToBeEdited.id}) else { return }
            notBoughtShoppingListItems[index] = itemToBeEdited
        }
        updateState()
        showEditItemSheet.toggle()
        self.itemToBeEdited = createEmptyShoppingItem()
    }
    
    private func searchItems(searchText: String) {
        let list = toSearchList()
        if searchText.isEmpty {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                self.shoppingListItemsToDisplay = list
            }
            return
        }
        isSearching = true
        let searchResultList = list.filter({$0.description.contains(searchText) || $0.name.contains(searchText)})
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.shoppingListItemsToDisplay = searchResultList
        }
    }
    
    private func toSearchList() -> [ShoppingItem] {
        let list: [ShoppingItem]
        switch shoppingListState {
        case .bought:
            list = boughtShoppingListItems
        case .notBought:
            list = notBoughtShoppingListItems
        }
        return list
    }
    
    private func endSorting() {
        isSorting = true
        switch sortInputs.method {
        case .ascending:
            sortAscendingly()
        case .descending:
            sortDescendingly()
        }
    }

    private func sortAscendingly() {
        var sortResultList = shoppingListItemsToDisplay
        switch sortInputs.criteria {
        case .name:
            sortResultList.sort(by: {$0.name < $1.name})
        case .quantity:
            sortResultList.sort(by: {Int($0.quantity) ?? 0 < Int($1.quantity) ?? 0})
        case .description:
            sortResultList.sort(by: {$0.description < $1.description})
        }
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.shoppingListItemsToDisplay = sortResultList
        }
    }
    
    private func sortDescendingly() {
        var sortResultList = shoppingListItemsToDisplay
        switch sortInputs.criteria {
        case .name:
            sortResultList.sort(by: {$0.name > $1.name})
        case .quantity:
            sortResultList.sort(by: {Int($0.quantity) ?? 0 > Int($1.quantity) ?? 0})
        case .description:
            sortResultList.sort(by: {$0.description > $1.description})
        }
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.shoppingListItemsToDisplay = sortResultList
        }
    }
    
    private func isBoughtToggled(for item: ShoppingItem) {
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
        if isSearching {
            searchItems(searchText: searchText)
        } else {
            updateState()
        }
    }
    
    //MARK: - Helping functions, remove redundant code with calling them
    
    private func updateState(_ state: ShoppingListState? = nil) {
        shoppingListState = state ?? shoppingListState
    }
    
    private func setDisplayListAccordingly(_ state: ShoppingListState? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state ?? self.shoppingListState {
            case .bought:
                self.shoppingListItemsToDisplay = self.boughtShoppingListItems
            case .notBought:
                self.shoppingListItemsToDisplay = self.notBoughtShoppingListItems
            }
        }
    }
    
    // MARK: - Setup Publishers
    private func setupPublishers() {
        
        toggledItemPublisher
            .dropFirst()
            .sink {[weak self] newValue in
                guard let self = self else { return }
                self.isBoughtToggled(for: newValue)
            }.store(in: &cancellable)
        
        listStatePublisher
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.setDisplayListAccordingly(newValue)
            }
            .store(in: &cancellable)
        
        clearSortPublisher
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.setDisplayListAccordingly(self.shoppingListState)
                self.sortInputs = (.ascending, .name)
                self.isSorting = false
            }
            .store(in: &cancellable)
        
        doneSortPublisher
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.endSorting()
            }
            .store(in: &cancellable)
        
        doneEditingPublisher
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.endEditing()
            }
            .store(in: &cancellable)
        
        doneNewItemPublisher
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.addNewItem()
            }
            .store(in: &cancellable)
        
        searchTextPublisher
            .dropFirst()
        //    .debounce(for: .milliseconds(800), scheduler: RunLoop.main) this if we will search remotely on server
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
