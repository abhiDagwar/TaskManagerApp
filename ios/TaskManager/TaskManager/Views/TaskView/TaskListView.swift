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
    @EnvironmentObject var viewModel: TaskViewModel
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
            TaskFormView(showAlert: .constant(false), alertMessage: .constant(""))
                            .environmentObject(viewModel) // ✅ Correct way to pass it
        }
        .onAppear {
            viewModel.fetchTasks()
        }
    }
}

#Preview {
    TaskListView()
}
