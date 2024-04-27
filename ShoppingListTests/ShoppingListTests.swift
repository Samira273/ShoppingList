//
//  ShoppingListTests.swift
//  ShoppingListTests
//
//  Created by Samira Marassy on 24/04/2024.
//

import XCTest
import ShoppingList
import Combine

final class ShoppingListTests: XCTestCase {
    
    var shoppingListViewModel: ShoppingListViewModel!
    private var cancellable = Set<AnyCancellable>()
    
    var items = [
        ShoppingItem(name: "Y", quantity: "10", description: "A", isOn: false),
        ShoppingItem(name: "K", quantity: "5", description: "B", isOn: false),
        ShoppingItem(name: "Z", quantity: "6", description: "C", isOn: false),
        ShoppingItem(name: "X", quantity: "13", description: "D", isOn: false),
        ShoppingItem(name: "C", quantity: "2", description: "E", isOn: false),
    ]
    
    override func setUp() {
        super.setUp()
        shoppingListViewModel = ShoppingListViewModel()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddItems() throws { // testing the adding item functionality
        let addItemsExpectations = expectation(description: "addItemExpectation")
        var resultList: [ShoppingItem] = []
        shoppingListViewModel.$shoppingListItemsToDisplay
            .sink { list in
                if self.items.count == list.count {
                    resultList = list
                    addItemsExpectations.fulfill()
                }
            }
              .store(in: &cancellable)
        
       addItems()
        
        wait(for: [addItemsExpectations], timeout: 1)
        XCTAssertEqual(items, resultList)
    }
    
    func addItems() {
        for item in items {
            shoppingListViewModel.newItemToBeAdded = item
            shoppingListViewModel.addNewItem()
        }
    }
    
    func testEditItem() throws { // testing the editing of an item functionality
        let editItemExpectations = expectation(description: "editItemExpectation")
        shoppingListViewModel.doneEditingPublisher
            .sink { check in
                if check {
                    editItemExpectations.fulfill()
                }
            }
              .store(in: &cancellable)
        
        addItems()
        items[3].quantity = "26"
        shoppingListViewModel.itemToBeEdited = items[3]
        shoppingListViewModel.doneEditing = true
        wait(for: [editItemExpectations], timeout: 1)
        XCTAssertEqual(items, shoppingListViewModel.shoppingListItemsToDisplay)
    }
    
    func testDeleteItem() throws { // testing the deletion of item functionality
        let deleteItemExpectations = expectation(description: "testdeleteitem")
        addItems()
        
        shoppingListViewModel.$shoppingListState
            .dropFirst(1)
            .sink { state in
                deleteItemExpectations.fulfill()
                
            }
              .store(in: &cancellable)

        var expectedResult = items
        expectedResult.remove(at: 1)
        shoppingListViewModel.deleteItem(at: [1])
        wait(for: [deleteItemExpectations], timeout: 1)
        XCTAssertEqual(expectedResult, shoppingListViewModel.shoppingListItemsToDisplay)
    }

    
    func testToggleIsBought() throws { //testing the isBoughtToggle which moves the item into bought list if we're displaying not bought items like we do here.
        let toggleItemExpectations = expectation(description: "toggleItemExpectation")
        addItems()
        shoppingListViewModel.$toggledItem
            .dropFirst()
            .sink { item in
                toggleItemExpectations.fulfill()
            }
              .store(in: &cancellable)
        shoppingListViewModel.toggledItem = items[4]
        items[4].isOn = true
        wait(for: [toggleItemExpectations], timeout: 1)
        XCTAssertEqual(items.count - 1, shoppingListViewModel.shoppingListItemsToDisplay.count)
        XCTAssertEqual([items[4]], shoppingListViewModel.boughtShoppingListItems )
    }
    
    func testFilterOnBoughtItems() throws { // testing the filter of the data with bought state.
        let boughtFilterItemExpectations = expectation(description: "testFilterOnBoughtItems")
        addItems()
        shoppingListViewModel.$shoppingListState
            .dropFirst(2)
            .sink { item in
                boughtFilterItemExpectations.fulfill()
            }
              .store(in: &cancellable)
        shoppingListViewModel.toggledItem = items[4]
        items[4].isOn = true
        shoppingListViewModel.shoppingListState = .bought
        wait(for: [boughtFilterItemExpectations], timeout: 1)
        XCTAssertEqual([items[4]], shoppingListViewModel.shoppingListItemsToDisplay)
    }
    
    func testSearchItems() throws { // testing search functionality
        let searchItemsExpectations = expectation(description: "searchItemsExpectation")
        addItems()
        shoppingListViewModel.$isSearching
            .dropFirst()
            .sink { check in
                if !check {
                    searchItemsExpectations.fulfill()
                }
            }.store(in: &cancellable)
        shoppingListViewModel.searchText = "X"
        shoppingListViewModel.isSearching.toggle()
        wait(for: [searchItemsExpectations], timeout: 1)
        XCTAssertEqual([items[3]], shoppingListViewModel.shoppingListItemsToDisplay)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
