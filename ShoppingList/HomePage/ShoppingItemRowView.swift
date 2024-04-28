//
//  ShoppingItemRowView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 24/04/2024.
//

import SwiftUI

struct ShoppingItemRowView: View {
    
    let item: ShoppingItem
//    @State var isOn: Bool 
    @Binding var toggledItem: ShoppingItem

    var body: some View {
        VStack (spacing: 0) {
            HStack (spacing: 50) {
                Text(item.quantity + "x " + item.name).bold()
                Toggle("", isOn: .constant(item.isOn))
                    .onTapGesture {
                        toggledItem = item
                    } // here's to override the tap gesture of row selection
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
    struct Preview: View {
        @State var shoppingItem = ShoppingItem(name: "lorem", quantity: "1", description: "ibson", isOn: false)
        var body: some View {
            ShoppingItemRowView(item: ShoppingItem(name: "lorem", quantity: "1", description: "ibson", isOn: false), toggledItem: $shoppingItem)
        }
    }
    return Preview()
}
