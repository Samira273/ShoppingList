//
//  ContentView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var showFilterItemsSheet: Bool = false
    @State private var showSortItemsSheet: Bool = false
    @StateObject private var viewModel = ShoppingListViewModel()
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.noItemsToDisplay {
                    VStack {
                        HStack {
                            Button {
                                showFilterItemsSheet.toggle()
                            } label: {
                                Image("filter").foregroundColor(.blue)
                                Text("Filter")
                            }.padding(20)
                            Spacer()
                            
                            Button {
                                showSortItemsSheet.toggle()
                            } label: {
                                Image("sort").foregroundColor(.blue)
                                Text("Sort")
                            }.padding(20)
                        }
                        HStack {
                            TextField("Search By Name Or Description", text: $viewModel.searchText)
                                .onChange(of: viewModel.searchText) {
                                    if !viewModel.searchText.isEmpty && !viewModel.isSearching {
                                        viewModel.isSearching.toggle()
                                    }
                                }
                                .onSubmit {
                                    if viewModel.isSearching {
                                        viewModel.isSearching.toggle()
                                    }
                                }
                                .disableAutocorrection(true)
                                .focused($searchIsFocused)
                                .padding(.horizontal, 40)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 45, alignment: .leading)
                                .background(Color(#colorLiteral(red: 0.9294475317, green: 0.9239223003, blue: 0.9336946607, alpha: 1)))
                                .clipped()
                                .cornerRadius(10)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 16)
                                    }
                                )
                            
                        }
                    }
                }
                List () {
                    ForEach(viewModel.shoppingListItemsToDisplay, id: \.id) { item in
                        ShoppingItemRowView(item: item, toggledItem: $viewModel.toggledItem)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.willEdit(item: item)
                                viewModel.showEditItemSheet.toggle()
                            }
                    }
                    .onDelete(perform: viewModel.deleteItem(at:))
                }
                .listRowSpacing(-15)
                .scrollContentBackground(.hidden)
                .padding([.leading, .trailing], -30)
            }
            .navigationTitle("Your Shopping List")
            .navigationBarTitleDisplayMode(.automatic)
        }
        
        .sheet(isPresented: $viewModel.showEditItemSheet) {
            AddItemView(shoppingItem: $viewModel.itemToBeEdited, doneItem: $viewModel.doneEditing).presentationDetents([.medium])
                .alert(viewModel.errorMessage, isPresented: $viewModel.showValidationErrorAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
        .sheet(isPresented: $viewModel.showAddItemSheet) {
            return AddItemView(shoppingItem: $viewModel.newItemToBeAdded, doneItem: $viewModel.doneNewItem).presentationDetents([.medium])
                .alert(viewModel.errorMessage, isPresented: $viewModel.showValidationErrorAlert) {
                    Button("OK", role: .cancel) { }
                }
        }
        .sheet(isPresented: $showFilterItemsSheet) {
            UIApplication.shared.endEditing()
            return VStack {
                Text("Filter By").bold().font(.title)
                HStack(alignment: .top, spacing: 10) {
                    Spacer()
                    RadioButtonView(title: "Bought", isSelected: viewModel.shoppingListState == .bought ? true : false)
                        .onTapGesture {
                            clearAndResignSearchTextField()
                            showFilterItemsSheet.toggle()
                            DispatchQueue.main.async {
                                self.viewModel.shoppingListState = .bought
                            }
                        }
                    Spacer()
                    RadioButtonView(title: "Not Bought", isSelected: viewModel.shoppingListState == .notBought ? true : false)
                        .onTapGesture {
                            clearAndResignSearchTextField()
                            showFilterItemsSheet.toggle()
                            DispatchQueue.main.async {
                                viewModel.shoppingListState = .notBought
                            }
                        }
                    Spacer()
                }.presentationDetents([.height(140)])
            }
            
        }
        .sheet(isPresented: $showSortItemsSheet) {
            UIApplication.shared.endEditing()

            return SortView(sortInputs: $viewModel.sortInputs, doneSortingTapped: $viewModel.doneSortTapped, clearTapped: $viewModel.clearSortTapped)
                .presentationDetents([.medium])
        }
        .safeAreaInset(edge: VerticalEdge.bottom) {
            HStack(spacing: -15) {
                Spacer()
                Image(systemName: "plus").foregroundColor(.blue)
                Button(action: {
                    viewModel.showAddItemSheet.toggle()
                }, label : {
                    Text("Add New Item").padding(.all, 20).foregroundColor(.blue).bold()
                })
                .accessibilityIdentifier("add_button")
                Spacer()
            }
            .background(Gradient(colors: [.white]))
            .border(Color.black.opacity(0.2), width: 0.5)
            .shadow(radius: 10)
            .frame(height: 0)
        }
    }
    
    private func clearAndResignSearchTextField() {
        viewModel.searchText = ""
        searchIsFocused = false
    }
}

#Preview {
    HomePageView()
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
