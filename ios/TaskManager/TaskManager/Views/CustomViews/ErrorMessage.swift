//
//  ErrorMessage.swift
//  TaskManager
//
//  Created by Abhishek G on 07/03/25.
//

import SwiftUI

struct ErrorMessage: View {
  var text: String
  
  var body: some View {
    HStack {
      Image(systemName: "exclamationmark.triangle")
      Text(text)
    }
    .font(.caption)
    .foregroundColor(Color("ErrorRed"))
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, 8)
  }
}

#Preview {
    ErrorMessage(text: "Warning! Please check the error message.")
}
