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
    @Binding var doneSortingTapped: Bool
    @Binding var clearTapped: Bool
    @State private var refreshView = false
    let ascendingWhiteImageName = "sort_ascending_white"
    let ascendingBlackImageName = "sort_ascending_black"
    let descendingWhiteImageName = "sort_descending_white"
    let descendingBlackImageName = "sort_descending_black"

    
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
                    clearTapped.toggle()
                    dismiss()
                }) {
                    HStack {
                        Text("Clear").fontWeight(.semibold)
                    }
                }.padding(20)
            }
            HStack {
                Button(action: {
                    sortInputs.method = .ascending
                }) {
                    HStack {
                        Image(sortInputs.method == .ascending ? ascendingWhiteImageName : ascendingBlackImageName)
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
                        Image(sortInputs.method == .descending ? descendingWhiteImageName : descendingBlackImageName)
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
                            refreshView.toggle()
                        }.id(refreshView)
                }
            }.padding(20)
            Button(action: {
                doneSortingTapped.toggle()
                dismiss()
            }, label: {
                Text("Done").bold()
                    .frame(width: 90, height: 50, alignment: .center)
            }).foregroundColor(.white)
            .background(Color.blue            .clipShape(RoundedRectangle(cornerRadius: 25)))
            .padding(30)
        }
        .padding([.top], -45)
    }
}

#Preview {
    struct Preview: View {
        @State var sortingInput: (method: SortingMethod, criteria: SortingCriteria) = (.ascending, .name)
        @State var clearTapped = false
        @State var doneTapped = false
        var body: some View {
            SortView(sortInputs: $sortingInput, doneSortingTapped: $doneTapped, clearTapped: $clearTapped)
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
