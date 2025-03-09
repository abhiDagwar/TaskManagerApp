//
//  CustomAlertView.swift
//  TaskManager
//
//  Created by Abhishek G on 07/03/25.
//

import SwiftUI

struct CustomAlertView: View {
  var title: String
  var message: String
  var primaryButtonTitle: String
  var primaryAction: () -> Void
  
  var body: some View {
    VStack(spacing: 20) {
      Text(title)
        .font(.title3.bold())
        .foregroundColor(Color("TextPrimary"))
      
      Text(message)
        .multilineTextAlignment(.center)
        .foregroundColor(Color("TextSecondary"))
      
      CustomButton(title: primaryButtonTitle, action: primaryAction)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 15)
        .fill(Color("BackgroundColor"))
        .shadow(radius: 10)
    )
    .padding(30)
  }
}

#Preview {
    CustomAlertView(title: "Success!", message: "You created the alert successfully!", primaryButtonTitle: "OK") {
        // Add action here
    }
}
