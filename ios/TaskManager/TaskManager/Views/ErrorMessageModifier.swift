//
//  ErrorMessageModifier.swift
//  TaskManager
//
//  Created by Abhishek G on 28/02/25.
//

import SwiftUI

struct ErrorMessageModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.caption)
      .foregroundColor(.red)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 4)
  }
}

extension View {
  func errorMessageStyle() -> some View {
    modifier(ErrorMessageModifier())
  }
}

#Preview {
    Text("This is an error message")
        .modifier(ErrorMessageModifier())
}

