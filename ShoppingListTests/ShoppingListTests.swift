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
        ShoppingItem(name: "A", quantity: "5", description: "B", isOn: false),
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

    func testAddItems() throws {
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
    
    func testEditItem() throws {
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
