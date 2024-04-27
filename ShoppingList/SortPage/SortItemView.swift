//
//  SortItemView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 26/04/2024.
//

import SwiftUI

struct SortItemView: View {
    @Binding var itemChecked: Bool
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: itemChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(itemChecked ? Color(UIColor.systemBlue) : Color.secondary)
                .onTapGesture {
                    self.itemChecked.toggle()
                }.padding(15)
            Text(text)
            Spacer()
        }
    }
}

#Preview {
    struct Preview: View {
        @State var checked: Bool = false
        var body: some View {
            SortItemView(itemChecked: $checked, text: "Element that requires checkmark!")
        }
    }
    return Preview()
}
