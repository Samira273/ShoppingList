//
//  ContentView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct HomePageView: View {
    
    
    var items = [
        ShoppingItem(name: "Milk", quantity: 1, description: "el mara3y liter w noss", isOn: true),
        ShoppingItem(name: "Cheese", quantity: 2, description: "gebna romy b7bha", isOn: false),
        ShoppingItem(name: "Oil", quantity: 3, description: "spray diet", isOn: true),
        ShoppingItem(name: "Coffe", quantity: 4, description: "silaz aw abo ouf", isOn: false),
        ShoppingItem(name: "Water", quantity: 6, description: "galon kbit", isOn: true),
        ShoppingItem(name: "Biscts", quantity: 6, description: "b smsm", isOn: false)
       ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.name) { item in
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
       
    }
           
}

#Preview {
    HomePageView()
}
