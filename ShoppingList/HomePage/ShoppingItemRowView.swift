//
//  ShoppingItemRowView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct ShoppingItemRowView: View {
    
    let item: ShoppingItem
    @State var isOn: Bool 
    
    init(item: ShoppingItem) {
        self.item = item
        self.isOn = item.isOn
    }

    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 50) {
                Text(item.quantity + "x " + item.name).bold()
                Toggle("", isOn: $isOn)
                      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
            .padding(15)
            Text(item.description).frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom], 15)
                .frame(alignment: .top)
                .foregroundColor(.secondary)
            
            .padding(.top, -15)


        }
        .background(Rectangle().fill(Color.white).cornerRadius(10).shadow(radius: 5)).padding(10)
        
    }
}

#Preview {
    ShoppingItemRowView(item: ShoppingItem(name: "lorem", quantity: "1", description: "ibson", isOn: false))
}
