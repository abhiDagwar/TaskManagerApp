//
//  CustomTextField.swift
//  TaskManager
//
//  Created by Abhishek G on 07/03/25.
//

import SwiftUI

struct CustomTextField: View {
  var title: String
  var icon: String?
  @Binding var text: String
  var isSecure = false
  
  var body: some View {
    HStack {
      if let icon = icon {
        Image(systemName: icon)
          .foregroundColor(Color("TextSecondary"))
      }
      
      Group {
        if isSecure {
          SecureField(title, text: $text)
        } else {
          TextField(title, text: $text)
        }
      }
      .foregroundColor(Color("TextPrimary"))
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color("SecondaryColor"), lineWidth: 1)
    )
  }
}

#Preview {
    CustomTextField(title: "TextField", icon: "paperplane.circle.fill", text: .constant("Hello, Preview!"), isSecure: true)
}
