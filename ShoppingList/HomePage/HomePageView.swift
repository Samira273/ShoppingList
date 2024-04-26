//
//  ContentView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var showAddItemSheet: Bool = false
    @State private var showEditItemSheet: Bool = false
    @StateObject private var viewModel = ShoppingListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if !$viewModel.shoppingListItemsToDisplay.isEmpty {
                    VStack {
                        HStack {
                            Button {
                                print("Filter button was tapped")
                            } label: {
                                Image("filter").foregroundColor(.blue)
                                Text("Filter")
                            }.padding(20)
                            Spacer()
                            
                            Button {
                                print("Sort button was tapped")
                            } label: {
                                Image("sort").foregroundColor(.blue)
                                Text("Sort")
                            }.padding(20)
                        }
                        HStack {
                            TextField("Search By Name Or Description", text: $viewModel.searchText)
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
                    ForEach(viewModel.shoppingListItemsToDisplay, id: \.name) { item in
                        ShoppingItemRowView(item: item, isBoughtToggled: {
                            viewModel.isBoughtToggled(for: item)
                        })
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.willEdit(item: item)
                            showEditItemSheet.toggle()
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
        
        .sheet(isPresented: $showEditItemSheet) {
            AddItemView(shoppingItem: $viewModel.itemToBeEdited, doneItem: {
                self.viewModel.endEditing()
            }).presentationDetents([.medium])
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView(shoppingItem: $viewModel.newItemToBeAdded, doneItem: {
                self.viewModel.addNewItem()
            }).presentationDetents([.medium])
        }
        .safeAreaInset(edge: VerticalEdge.bottom) {
            HStack(spacing: -15) {
                Spacer()
                Image(systemName: "plus").foregroundColor(.blue)
                Button(action: {
                    showAddItemSheet.toggle()
                    }, label : {
                        Text("Add New Item").padding(.all, 20).foregroundColor(.blue).bold()
                    })
                Spacer()
            }
            .background(Gradient(colors: [.white]))
            .border(Color.black.opacity(0.2), width: 0.5)
            .shadow(radius: 10)
            .frame(height: 0)
        }
    }
}

#Preview {
    HomePageView()
}
