//
//  TaskListView.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI

/// View displaying the list of tasks for the current user
struct TaskListView: View {
    // MARK: - Properties
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    
    // MARK: - Body
    var body: some View {
        // Remove the NavigationView since this view is already inside a NavigationStack from ContentView
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
            } else if viewModel.tasks.isEmpty {
                VStack {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 70))
                        .foregroundColor(Color("PrimaryColor"))
                        .padding()
                    
                    Text("No Tasks Yet")
                        .font(.title2)
                        .foregroundColor(Color("TextPrimary"))
                        .padding(.bottom, 5)
                    
                    Text("Add a task to get started")
                        .foregroundColor(Color("TextSecondary"))
                }
            } else {
                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRow(task: task)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    if let id = task.id {
                                        viewModel.deleteTask(id: id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTask = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            // Text("Add Task Form Will Go Here")
            // This would be a TaskFormView in the future
            // Test to show TaskFormView
            TaskFormView(viewModel: TaskViewModel(), showAlert: .constant(false), alertMessage: .constant(""))
        }
        .onAppear {
            viewModel.fetchTasks()
        }
    }
}

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
    TaskListView()
}
