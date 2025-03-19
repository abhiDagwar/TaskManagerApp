//
//  TaskFormView.swift
//  TaskManager
//
//  Created by Abhishek G on 18/03/25.
//

import SwiftUI

struct TaskFormView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TaskViewModel // ✅ Correct way to access shared ViewModel
    
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var status = "Todo"
    
    private let statuses = ["Todo", "In Progress", "Done"]
    private let authService = AuthService.shared
    var task: Task?
    
    // ✅ Custom Initializer that correctly handles @Binding properties
        init(task: Task? = nil, showAlert: Binding<Bool>, alertMessage: Binding<String>) {
            self.task = task
            self._showAlert = showAlert
            self._alertMessage = alertMessage
            
            // ✅ Properly initializing @State variables
            _title = State(initialValue: task?.title ?? "")
            _description = State(initialValue: task?.description ?? "")
            _dueDate = State(initialValue: task?.dueDate ?? Date())
            _status = State(initialValue: task?.status ?? "Todo")
        }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Task Title
                        InputField(title: "Task Title", text: $title, icon: "text.badge.plus")
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $description)
                                .frame(minHeight: 120)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        }
                        
                        // Due Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due Date")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                                .padding(8)
                        }
                        
                        // Status Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Picker("Status", selection: $status) {
                                ForEach(statuses, id: \..self) { status in
                                    Text(status).tag(status)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .padding()
                }
                
                // Buttons
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: handleTaskAction) {
                        Text(task == nil ? "Add Task" : "Save Changes")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(title.isEmpty)
                }
                .padding()
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let task = task { loadTaskData(task) }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func handleTaskAction() {
        if let task = task { updateTask(task) } else { addTask() }
        dismiss()
    }
    
    private func loadTaskData(_ task: Task) {
        title = task.title
        description = task.description
        dueDate = task.dueDate
        status = task.status
    }
    
    private func addTask() {
        
        let newTask = Task(
            id: nil, // Firestore will generate the ID
            title: title,
            description: description,
            createdAt: Date(),
            dueDate: dueDate, // Due date
            status: status
        )
                        
        viewModel.addTask(newTask) { success in
                    handleResult(success: success, successMessage: "Task added successfully")
                }
        
    }
    
    private func updateTask(_ task: Task) {
        // TODO: Implemete the updateTask
        /*
        let updatedTask = Task(id: task.id, title: title, description: description, dueDate: dueDate, status: status, userId: authService.currentUserId)
        viewModel.updateTask(task: updatedTask) { success in
            handleResult(success: success, successMessage: "Task updated successfully")
        }
         */
    }
    
    private func handleResult(success: Bool, successMessage: String) {

        alertMessage = success ? successMessage : (viewModel.errorMessage ?? "Failed to save task.")
            showAlert = true
        
    }
}

// MARK: - InputField Component
struct InputField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                
                TextField("", text: $text)
                    .textInputAutocapitalization(.none)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
        }
    }
}

#Preview {
    TaskFormView(task: Task(title: "New Task", description: "Preview task", createdAt: Date(), dueDate: Date(), status: "Pending"),
                     showAlert: .constant(false),
                     alertMessage: .constant(""))
            .environmentObject(TaskViewModel()) // ✅ Create a new instance for preview
}

