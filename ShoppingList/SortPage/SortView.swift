//
//  SortView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 26/04/2024.
//

import SwiftUI

struct SortView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var sortInputs: (method: SortingMethod, criteria: SortingCriteria)
    var doneTapped: () -> Void

    
    var body: some View {
        VStack(spacing: -10) {
            HStack {
                Button(action: {
                    self.dismiss()
                }) {
                    HStack {
                        Text("Cancel").fontWeight(.semibold)
                    }
                }.padding(20)
                Spacer()
                Text("Sort By").bold()
                Spacer()
                Button(action: {
                    doneTapped()
                }) {
                    HStack {
                        Text("Done").fontWeight(.semibold)
                    }
                }.padding(20)
            }
            HStack {
                Button(action: {
                    sortInputs.method = .ascending
                }) {
                    HStack {
                        Image(sortInputs.method == .ascending ? "sort_ascending_white" : "sort_ascending_black")
                        Text("Ascending").fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundColor(sortInputs.method == .ascending ? .white : .black)
                .background(sortInputs.method == .ascending ? Color.blue : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 25))

                Button(action: {
                    sortInputs.method = .descending
                }) {
                    HStack {
                        Image(sortInputs.method == .descending ? "sort_descending_white" : "sort_descending_black")
                        Text("Descending").fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundColor(sortInputs.method == .descending ? .white : .black)
                .background(sortInputs.method == .descending ? Color.blue : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.newLightGray.clipShape(RoundedRectangle(cornerRadius: 25)))
            .padding()
            VStack {
                ForEach(SortingCriteria.allCases) {criteria in
                    SortItemView(itemChecked: .constant(sortInputs.criteria == criteria), text: criteria.title)
                        .onTapGesture {
                            sortInputs.criteria = criteria
                        }
                }
            }.padding()
        }
        .padding([.top], -125)
    }
}

#Preview {
    struct Preview: View {
        @State var sortingInput: (method: SortingMethod, criteria: SortingCriteria) = (.ascending, .name)
        var body: some View {
            SortView(sortInputs: $sortingInput, doneTapped: {})
        }
    }
    return Preview()
}

enum SortingMethod {
    case ascending
    case descending
}

enum SortingCriteria: CaseIterable, Identifiable {
    
    var id : String { UUID().uuidString }

    case name
    case quantity
    case description
    
    var title: String {
        switch self {
        case .name:
            "Name"
        case .quantity:
            "Quantity"
        case .description:
            "Description"
        }
    }
}
