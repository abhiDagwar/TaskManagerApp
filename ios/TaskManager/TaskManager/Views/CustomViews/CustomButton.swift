//
//  CustomButton.swift
//  TaskManager
//
//  Created by Abhishek G on 07/03/25.
//

import SwiftUI

struct CustomButton: View {
  var title: String
  var action: () -> Void
  var isLoading = false
  
  var body: some View {
    Button(action: action) {
      HStack {
        if isLoading {
          ProgressView()
            .tint(.white)
        }
        Text(title)
          .font(.headline)
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color("PrimaryColor"))
      .foregroundColor(.white)
      .cornerRadius(10)
      .opacity(isLoading ? 0.7 : 1.0)
    }
    .disabled(isLoading)
  }
}

#Preview {
    CustomButton(title: "Button") {
        //Handle button action
    }
}
