//
//  RadioButtonView.swift
//  ShoppingList
//
//  Created by Samira Marassy on 26/04/2024.
//

import SwiftUI

struct RadioButtonView: View {
    
    let title: String
    var isSelected: Bool
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            circleView
            labelView
        }
    }
}

extension RadioButtonView {
  @ViewBuilder var labelView: some View {
      Text(title).fontWeight(.semibold)
  }
  
  @ViewBuilder var circleView: some View {
     Circle()
          .fill(isSelected ? Color.green: .clear) // Inner circle color
       .padding(4)
       .overlay(
          Circle()
            .stroke(Color.gray, lineWidth: 1)
        ) // Circle outline
       .frame(width: 20, height: 20)
  }
}

#Preview {
    RadioButtonView(title: "koko", isSelected: false)
}
