//
//  TaskRow.swift
//  TaskManager
//
//  Created by Abhishek G on 19/03/25.
//

import SwiftUI

/// Row view for displaying a single task
struct TaskRow: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title)
                .font(.headline)
                .foregroundColor(Color("TextPrimary"))
            
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(Color("TextSecondary"))
                .lineLimit(2)
            
            HStack {
                Label {
                    Text(task.dueDate, style: .date)
                        .font(.caption)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(Color("PrimaryColor"))
                }
                
                Spacer()
                
                Text(task.status)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor(for: task.status))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Returns the color associated with a task status
    /// - Parameter status: The status string
    /// - Returns: A color representing the status
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Todo":
            return .blue
        case "In Progress":
            return .orange
        case "Done":
            return .green
        default:
            return .gray
        }
    }
}

#Preview {
    let task = Task(title: "New Task", description: "This is the new task created to view in preview.", createdAt: Date(), dueDate: Date(), status: "Pending")
    TaskRow(task: task)
}
