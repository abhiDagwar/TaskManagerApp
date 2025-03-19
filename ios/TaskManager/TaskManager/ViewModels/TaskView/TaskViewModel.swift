//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Abhishek G on 13/02/25.
//

import SwiftUI

/// ViewModel for managing task data and operations
class TaskViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// List of tasks for the current user
    @Published var tasks: [Task] = []
    
    /// Loading state indicator
    @Published var isLoading: Bool = false
    
    /// Error message for task operations
    @Published var errorMessage: String? = nil
    
    // MARK: - Private Properties
    
    /// Authentication service to get current user
    private let authService: AuthService
    
    /// API service for task-related network requests
    private let apiService: APIService
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with required services
    /// - Parameters:
    ///   - authService: Service for user authentication
    ///   - apiService: Service for API calls
    init(authService: AuthService = AuthService.shared, apiService: APIService = APIService()) {
        self.authService = authService
        self.apiService = apiService
    }
    
    // MARK: - Public Methods
    
    /// Fetches all tasks for the current user
    func fetchTasks() {
        // This would fetch tasks from an API or local database
        // For now, it's a placeholder for future implementation
        isLoading = true
        
        // Implement API call
        
        // 1. Get the userId
        guard let userId = authService.userId else {
            print("User not autheticated")
            return
        }
        
        // 2. Call fetch task api service
        apiService.fetchTasks(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let task):
                    self?.tasks = task
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching tasks: \(error.localizedDescription)")
                }
                self?.isLoading = false
            }
        }
    }
    
    /// Adds a new task
    /// - Parameter task: The task to be added
    func addTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        guard let userId = authService.userId else {
            self.errorMessage = "User not authenticated"
            return
        }
        isLoading = true
        self.errorMessage = nil
        
        // Implement API call
        apiService.createTask(for: userId, task) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newTask):
                    self?.tasks.insert(newTask, at: 0)
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    /// Updates an existing task
    /// - Parameter task: The task with updated values
    func updateTask(_ task: Task) {
        // This would call an API to update the task
        // For now, just update local array
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks[index] = task
            }
        }
    }
    
    /// Deletes a task
    /// - Parameter id: The ID of the task to delete
    func deleteTask(id: String) {
        // This would call an API to delete the task
        // For now, just remove from local array
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            self.tasks.removeAll { $0.id == id }
        }
    }
}

