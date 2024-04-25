//
//  ContentView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var showAddItemSheet: Bool = false
    @StateObject private var viewModel = ShoppingListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notBoughtShoppingListItems, id: \.name) { item in
                    ShoppingItemRowView(item: item)
                        .listRowSeparator(.hidden)

                }
            }
            .listRowSpacing(-15)
            .scrollContentBackground(.hidden)
            .padding([.leading, .trailing], -30)
            .navigationTitle("Your Shopping List")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView(shoppingItem: $viewModel.newItemToBeAdded, addItem: {
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
