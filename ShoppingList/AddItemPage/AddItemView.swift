//
//  AddItemView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 25/04/2024.
//

import SwiftUI

struct AddItemView: View {
    @State private var formFields: [String] = Array(repeating: "", count: 3)
    @Environment(\.dismiss) var dismiss
    @Binding var shoppingItem: ShoppingItem
    var addItem: () -> Void

    
    var body: some View {
        
        NavigationStack {
            HStack(spacing: -65) {
                Button(action: {
                    self.dismiss()
                }, label: {
                    Text("Cancel").fontWeight(.semibold).padding(10)
                })
                Spacer()
                Text("Add Item").fontWeight(.semibold)
                Spacer()
                Button(action: {
                    self.addItem()
                    self.dismiss()
                }, label: {
                    Text("Done").fontWeight(.semibold).padding(10)
                }).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            }
            
            Form {
                ForEach(0..<formFields.count, id: \.self) { index in
                    HStack {
                        Text(getTextFieldTitle(index: index)).fontWeight(.semibold)
                        TextField("", text: getBindingFor(index: index)!, axis: .vertical)
                            .disableAutocorrection(true)
                            .multilineTextAlignment(.leading).padding(10).keyboardType(getKeyboardType(index: index))
                    }
                }
                //            HStack {
                //                Text("Is Bought").fontWeight(.semibold)
                //                Toggle("", isOn: $shoppingItem.isOn)
                //                      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                //            }
            }
        }
    }
    
    func getBindingFor(index: Int) -> Binding<String>? {
        switch index {
        case 0: return $shoppingItem.name
        case 1: return $shoppingItem.quantity
        case 2: return $shoppingItem.description
        default: return nil
        }
    }
   
    func getTextFieldTitle(index: Int) -> String {
        switch index {
        case 0: return "Name:"
        case 1: return "Quantity:"
        case 2: return "Description:"
        default: return ""
        }
    }
    
    func getKeyboardType(index: Int) -> UIKeyboardType {
        switch index {
        case 1: return .numberPad
        default: return .default
        }
    }
}

#Preview {
    struct Preview: View {
        @State var shoppingItem = ShoppingItem(name: "", quantity: "0", description: "", isOn: false)
        var body: some View {
            AddItemView(shoppingItem: $shoppingItem, addItem: {})
        }
    }
    return Preview()
}
